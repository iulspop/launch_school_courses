require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

require "pathname"

class Ressource
  include Comparable

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

  def <=>(other_ressource)
    self.name <=> other_ressource.name
  end
end

def directory_children(directory_path)
  file_names = Dir.entries(directory_path).reject { |file| file == "." || file == ".." }
  file_names.map { |file_name| Ressource.new(directory_path, file_name) }
end

get "/" do
  sort = params[:sort]

  @ressource_list = directory_children("public")
  @ressource_list = @ressource_list.sort         if sort == "ascending"
  @ressource_list = @ressource_list.sort.reverse if sort == "descending"

  erb :home
end