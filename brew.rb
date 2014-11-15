
require 'haml'
require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'date'

#Set upstream service server API address here.  Addiitonal API structure covered later
$server='http://192.168.1.113:4568'
#debug flag 
$debug=true

def debugging (dmessage) #dmessage is message to pass to log
#Debugging routine
	now=Time.now
	puts "#{now}: #{dmessage}" if $debug==true
end

# Method to post data
def post (dir, data) #DIR is path to REST, Data is HASH of post data
	begin
		address=$server + dir
		uri = URI.parse(address)
		debugging "Post URI: #{uri}, data: #{data}"
		request=Net::HTTP.post_form(uri,data)
		debugging "Response #{request}"
		return request
	rescue Exception =>msg
		response={'body'=>msg,'code'=>401, 'exception' =>true}
	end
end

#Method to get data
def get (dir) #DIR is path to RES
	begin
		address=$server+dir
		uri = URI.parse(address)
		debugging "Get URI: #{uri}"
		request = Net::HTTP.get_response(uri)
		debugging "Response #{request}"	
		body=request.body
		debugging "Body: #{body}"	
		body=JSON.parse (body)
		code=request.code
		debugging "Response Code: #{code}"
		response={'body'=>body,'code'=>code,'exception'=>false}
		debugging "Response content: #{response}"
		return response
	rescue Exception =>msg
		response={'body'=>msg,'code'=>401, 'exception' =>true}
		debugging "Response content: #{response}"
		return response
	end

end

configure do
# Configuation settings for service.
	set :bind, '0.0.0.0'
	set :port, '4567'
end

get '/' do
#Serve root URI	
	settings = get '/bbp/api/v1.0/status/0'
	device1 = get '/bbp/api/v1.0/status/1'
	device2 = get '/bbp/api/v1.0/status/2'
	debugging "Settings: #{settings}, Device1: #{device1}, device2: #{device2}"

	if (settings['exception']==true) or (device1['exception']==true) or (device2['exception']==true)
		#Error section
		puts 'warning'
	else
		cycling=settings['body']['device']['Cycling']
		settemp=settings['body']["device"]["Set Temp"]
		dc1tempc=device1['body']["device"]["Temp C"]
		dc1tempf=device1['body']["device"]["Temp F"]
		dc2tempc=device2['body']["device"]["Temp C"]
		dc2tempf=device2['body']["device"]["Temp F"]
	end
	
	haml :brewhome, :locals => {:temp1=>dc1tempf,:temp2=>dc2tempf,:rsettemp=>settemp,:engaged=>cycling}



	
end

post '/settemp' do
	#engage heat cycle
	temp=params[:htemp]
	cycle_length=params[:hcycle_length]
	duty_cycle=params[:hduty_cycle]
	sensor_id=params[:hsensor_id]
	heating_element_id=8
	data = {'cycle_length' => cycle_length, 'duty_cycle' => duty_cycle,'sensor_id' =>sensor_id, 'temp'=>temp, 'heating_element_id' => heating_element_id}

	response = post '/bbp/api/v1.0/set_temp', data
	redirect '/'
end

get "/brewedit" do
	#Load edit page
	haml :brewedit, :locals => {:settemp=>"0", :dutycycle=>".5",:cyclelength=>"4",:sensorselect=>"null"}
end

get "/brewstop" do
	#Load heat cycle stop confirm page
	settings = get '/bbp/api/v1.0/status/0'
	
	if (settings['exception']==true)
		puts 'warning'
	else
		cycling=settings['body']['device']['Cycling']
	end
	haml :brewstop, :locals => {:engaged=>cycling}
end

post '/stoptemp' do
	#stop heat cycle
	data={"blank"=>0}
	response = post '/bbp/api/v1.0/stop_set_temp', data

	redirect '/'
	#haml :brewhome, :locals => {:temp1 => '14',:temp2=>'18',:rsettemp=>$esettemp}
end
