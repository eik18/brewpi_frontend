
# This is a test harness file
require 'haml'
require 'sinatra'
require 'json'
require 'net/http'

$esettemp="0"

configure do
	set :bind, '0.0.0.0'
	set :port, '4568'
end


get '/status' do
	content_type :json
	{ :key1 => 'value1', :key2 => 'value2' }.to_json

end


