require 'socket'

server = TCPServer.new(3000)

def parse_request_line(request_line)
  http_method, path_and_params = request_line.split(' ')
  path, params = path_and_params.split("?")

  if params.nil?
    params = {}
  else
    params_array = params.split("&").map { |param| param.split("=") }
    params = params_array.map { |(key, value)| [key.to_sym, value.to_i] }.to_h
  end

  [http_method, path, params]
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  http_method, path, params = parse_request_line(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"

  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params[:number]
  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Substract one</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end