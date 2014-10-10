require 'haml'
require 'sinatra'
require 'json'
require 'net/http'



configure do
	set :bind, '0.0.0.0'
	set :port, '4567'
end
esettemp="0"
get '/' do
	haml :brewhome, :locals => {:temp1 => '14',:temp2=>'18',:rsettemp=>esettemp}
end

get "/brewedit" do
	haml :brewedit, :locals => {:settemp=>"0", :dutycycle=>".5",:cyclelength=>"4",:sensorselect=>"null"}
end

post "/brewpost" do
	esettemp = params[:settemp]
	redirect '/'
end


