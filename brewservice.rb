
# This is a test harness file
require 'haml'
require 'sinatra'
require 'json'
require 'net/http'
require 'jsonify'

$esettemp="0"

configure do
	set :bind, '0.0.0.0'
	set :port, '4568'
end


get '/bbp/api/v1.0/status' do
	# content_type :json

	config = [{"cycle_length"=> 4, "description" => "Relay with heating element", "dev_id" => 8, "duty_cycle"=> 1, "id"=> 0, "type"=> "heating_element"}, {"description"=>"One wire temperature sensor", "dev_id"=> "28-000004e0b909", "id"=>1,"type"=>"temp_sensor"},{"description"=>"One wire temperature sensor", "dev_id"=>"28-000004ce5048", "id"=> 2, "type"=> "temp_sensor"}]
	json = Jsonify::Builder.new(:format => :pretty)
	json.config (config)
	json.compile!
end


#code yet to be factored

get '/bbp/api/v1.0/status/0' do
	data = {"Cycling"=> 0, "Number of current cycles"=> 1298, "On"=> 0, "Set Temp"=>220}
  json = Jsonify::Builder.new(:format => :pretty)
  json.device (data)
  json.compile!
end

get '/bbp/api/v1.0/status/1' do
  data={"Temp C"=> 21.0, "Temp F"=> 69.8}
  json = Jsonify::Builder.new(:format => :pretty)
  json.device (data)
  json.compile!
end

get '/bbp/api/v1.0/status/2' do
  data={"Temp C"=> 24.0, "Temp F"=> 80.8}
  json = Jsonify::Builder.new(:format => :pretty)
  json.device (data)
  json.compile!
end

post '/bbp/api/v1.0/set_temp' do

end

=begin
post '/bbp/api/v1.0/stop_set_temp' do

Heating device 0 stopped.

end
=end
