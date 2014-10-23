require 'haml'
require 'sinatra'
require 'json'
require 'net/http'
require 'uri'

$esettemp="0"
$server='http://192.168.1.113:4568'



# Method to post data
def post (dir, data) #DIR is path to REST, Data is HASH of post data

	address=$server + dir
	uri = URI.parse(address)
	#http = Net::HTTP.new(uri.host, uri.port)
	request=Net::HTTP.post_form(uri,data)	
	#response=http.request(request)
end

#Method to get data
def get (dir) #DIR is path to RES
	begin
		address=$server+dir
		uri = URI.parse(address)
		#http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP.get_response(uri)
		body=request.body
		body=JSON.parse (body)
		code=request.code
		response={:body=>body,:code=>code,:exception=>false}
		return response
		#response=http.request(request)
	rescue Exception =>msg
		response={:body=>msg,:code=>401, :exception =>true}

		return response
	end

end

configure do
	set :bind, '0.0.0.0'
	set :port, '4567'
end

get '/' do
	
	settings = get '/bbp/api/v1.0/status/0'
	sensor1= get '/bbp/api/v1.0/status/1'
	sensor2= get '/bbp/api/v1.0/status/2'

	

	haml :brewhome, :locals => {:temp1 => '14',:temp2=>'18',:rsettemp=>$esettemp}
end

post '/' do
	temp=params[:htemp]
	cycle_length=params[:hcycle_length]
	duty_cycle=params[:hduty_cycle]
	sensor_id=params[:hsensor_id]
	heating_element_id=8
	set_temp=220
	data = {:cycle_length => cycle_length, :duty_cycle => duty_cycle,:sensor_id =>sensor_id, :temp=>temp, :heating_element_id => heating_element_id, :set_temp=set_temp}

	response = post '/bbp/api/v1.0/set_temp', data



	haml :brewhome, :locals => {:temp1 => '14',:temp2=>'18',:rsettemp=>$esettemp}
end

get "/brewedit" do
	haml :brewedit, :locals => {:settemp=>"0", :dutycycle=>".5",:cyclelength=>"4",:sensorselect=>"null"}
end

=begin
post "/brewpost" do
	$esettemp = params[:settemp]
	redirect '/'
end

get "/brewedit-test" do
	haml :brewedittest
end
=end
