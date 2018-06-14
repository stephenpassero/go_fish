require_relative 'client'

client = Client.new("Player1")


  # rescue Errno::ECONNREFUSED
  #   puts "Waiting for server to arrive..."
  #   sleep (3)
  #
  # rescue EOFError
  #   puts "Game over!"
  #   should_connect = false
  #
  # rescue Errno::ECONNRESET
  #   should_connect = false;
  # end
