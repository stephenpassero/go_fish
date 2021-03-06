require 'socket'
require_relative 'request'
require_relative 'response'
require 'pry'


class Client
  attr_accessor(:name)
  attr_reader(:socket)
  def initialize(name)
    @socket = TCPSocket.new("localhost", 3001)
    @name = name
  end

  def get_output_from_server()
    return @socket.gets
  end
  # To-do - Test this method!
  def convert_deck(arr_of_cards)
    arr_of_cards.each do |card|
      # Remove the "Your Cards:" from the first element
      if arr_of_cards.index(card) == 0
        card.slice!(0, 12)
      end
    end
  end

  def convert_card(card_string)
    card_parts = card_string.split('-')
    card_parts.delete('of')
    # Gets the first letters of each item the the array and puts them together in a string
    new_card_string = "#{card_parts[1][0, 1].downcase}#{card_parts[0][0, 1].downcase}"
    if new_card_string[-1] == "1"
      new_card_string.insert(2, '0')
    end
    return new_card_string
  end

  def get_input()
    answer = gets
    @socket.puts answer
  end

  def prompt_for_input()
    provide_input("Who would you like to ask for what?")
    provide_input("Example: Ask Player3 for a K")
    response = ""
    until response != ""
      response = gets
      sleep(0.001)
    end
    if response != ""
      request = convert_to_request(response)
      return request
    end
  end

  def convert_to_request(string)
    string = string.chomp
    regex = /(player\d).*\s(\w+)$/
    if string
      matches = string.match(regex)
    end
    if matches
      if matches == nil
        return ""
      else
        target = matches[1]
        card_rank = matches[2]
        return Request.new(@name, card_rank, target)
      end
    end
  end

  def decipher(response)
    new_response = Response.from_json(response)
    text = ""
    if new_response.fisher.downcase == @name.downcase
      text = "You asked #{new_response.target} for a #{new_response.rank}"
      if new_response.card == false
        new_text = "#{new_response.target} did not have a #{new_response.rank}. Go Fish!"
      else
        new_text = "You took a #{new_response.rank} from #{new_response.target}"
      end
      provide_input(text)
      provide_input(new_text)
    elsif new_response.target.downcase == @name.downcase
      text = "#{new_response.fisher} asked you for a #{new_response.rank}"
      if new_response.card == false
        new_text = "You did not have a #{new_response.rank}. #{new_response.fisher} went fishing."
      else
        new_text = "#{new_response.fisher} took a #{new_response.rank} from you"
      end
      provide_input(text)
      provide_input(new_text)
    else
      text = "#{new_response.fisher} asked #{new_response.target} for a #{new_response.rank}"
      if new_response.card == false
        new_text = "#{new_response.target} did not have a #{new_response.rank}. #{new_response.fisher} went fishing."
      else
        new_text = "#{new_response.fisher} took a #{new_response.rank} from #{new_response.target}"
      end
      provide_input(text)
      provide_input(new_text)
    end
    return text
    return new_text
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
    puts(text)
  end
end
