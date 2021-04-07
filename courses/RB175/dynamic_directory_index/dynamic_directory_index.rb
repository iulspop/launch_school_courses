require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

require "pathname"

class Ressource
  def initialize(directory_path, file_name)
    @directory_path = directory_path
    @file_name = file_name
  end

  def name
    @file_name
  end

  def path
    "/" + @file_name
  end
end

def directory_children(directory_path)
  file_names = Dir.entries(directory_path).reject { |file| file == "." || file == ".." }
  file_names.map { |file_name| Ressource.new(directory_path, file_name) }
end

get "/" do
  @ressource_list = directory_children("public")
  erb :home
end