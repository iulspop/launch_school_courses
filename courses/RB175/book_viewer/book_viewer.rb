require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @hello = "title"
  erb :home
end
