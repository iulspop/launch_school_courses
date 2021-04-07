require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @chapter_titles = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1" 
  @chapter_titles = File.readlines("data/toc.txt")
  @chapter = File.readlines("data/chp1.txt")

  erb :chapter
end