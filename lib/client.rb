require 'socket'
require_relative 'request'
require_relative 'response'
require 'pry'


class Client
  attr_reader(:name)
  def initialize(name)
    @socket = TCPSocket.new("localhost", 3001)
    @name = name
rescue Errno::ECONNREFUSED
  puts "Waiting for server to arrive..."
  sleep(1)
  end

  def prompt_for_input()
    provide_input("Who would you like to ask for what?")
    provide_input("Example: Ask Player3 for a 9")
    response = ""
    until response != ""
      response = capture_output()
    end
    regex = /(player\d).*\s(\w+)$/
    matches = response.match(regex)
    target = matches[1]
    card_rank = matches[2]
    return request = Request.new(@name, card_rank, target).to_json
  end

  def decipher(response)
    new_response = Response.from_json(response)
    text = ""
    if new_response.fisher == @name
      text = "You asked for and took a #{new_response.rank} from #{new_response.target}"
      provide_input(text)
    elsif new_response.target == @name
      text = "#{new_response.fisher} asked for and took a #{new_response.rank} from you"
      provide_input(text)
    else
      text = "#{new_response.fisher} asked for and took #{new_response.rank} from #{new_response.target}"
      provide_input(text)
    end
    return text
  end

  def close
    @socket.close if @socket
  end

  def capture_output(delay=0.01)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def provide_input(text)
    @socket.puts(text)
  end
end
