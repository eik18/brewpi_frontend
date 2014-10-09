require 'haml'
require 'sinatra'
require 'json'
require 'net/http'


configure do
	set :bind, '0.0.0.0'
	set :port, '4567'
end

get '/' do
	haml :brewhome, :locals => {:temp1 => '14',:temp2=>'18'}
end