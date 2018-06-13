require 'socket'
require 'pry'

should_connect = true

while should_connect do

  begin
    client = TCPSocket.new("localhost", 3001)

rescue Errno::ECONNREFUSED
  puts "Waiting for server to arrive..."
  sleep (3)

rescue EOFError
  puts "Game over!"
  should_connect = false

rescue Errno::ECONNRESET
  should_connect = false;
end
end
