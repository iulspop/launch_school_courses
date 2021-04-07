require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @chapter_titles = File.readlines("data/toc.txt")
  erb :home
end
