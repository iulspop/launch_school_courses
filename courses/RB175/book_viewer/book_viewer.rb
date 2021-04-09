require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  number = params[:number]
  @title = "Chapter #{number}"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.readlines("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  "Hi there #{params[:name]}!"
end