# post/get test

require 'json'
require 'net/http'
require 'uri'

$server='http://192.168.1.113:4568'
#uri = URI.parse("http://192.168.1.113:4568/status")


#http = Net::HTTP.new(uri.host, uri.port)
#request = Net::HTTP::Get.new(uri.request_uri)

#response = http.request(request)

#puts response.code             # => 301
#puts response.body             # => The body (HTML, XML, blob, whatever)
# Headers are lowercased
# puts response["cache-control"] # => public, max-age=2592000

#myhash=JSON.parse(response)



#output=JSON.parse(response.body)

#puts output["config"][1]["description"]
#puts testhash ["config"["cycle_length"]]
# Method to post data
def post (dir, data) #DIR is path to REST, Data is HASH of post data
	begin
		address=$server+dir
		uri = URI.parse(address)
		#http = Net::HTTP.new(uri.host, uri.port)
		response=Net::HTTP.post_form(uri, data)	
		#response=http.request(request)
		return response.code
	rescue Exception=>msg
		response={:body=>msg,:code=>401, :exception =>true}
		return response
	end
end

#Method to get data
def get (dir) #DIR is path to RES
	begin
		address=$server+dir
		#address << dir
		uri = URI.parse(address)
		#http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP.get_response(uri)
		body=request.body
		body=JSON.parse (body)
		code=request.code
		response={'body'=>body,'code'=>code,'exception'=>false}
		return response
		#response=http.request(request)
	rescue Exception =>msg
		response={'body'=>msg,'code'=>401, 'exception' =>true}

		return response
	end

end


=begin
	
rescue Exception => e
	
end	
temp=32
cycle_length=4
duty_cycle=4
sensor_id=1
heating_element_id=8
data = {:cycle_length => cycle_length, :duty_cycle => duty_cycle,:sensor_id =>sensor_id, :temp=>temp, :heating_element_id => heating_element_id}

response = post '/bbp/api/v1.0/set_temp', data
=end



settings = get '/bbp/api/v1.0/status/0'
cycling=settings['body']["device"]["Cycling"]
settemp=settings['body']["device"]["Set Temp"]

device1 = get '/bbp/api/v1.0/status/1'


puts device1
#puts response
#puts get '/bbp/api/v1.0/status/1'
#puts get '/bbp/api/v1.0/status/2'