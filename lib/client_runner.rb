require_relative 'client'
require_relative 'server'
require_relative 'request'
require 'colorize'

client = Client.new("Player1")
# Name the player correctly
text = client.get_output_from_server
player_num = text.chomp[-1]
client.name = "Player#{player_num}"

puts text
if player_num == "1"
  puts client.get_output_from_server
  client.get_input
  puts client.get_output_from_server
end

loop do
  hand = []
  turn = client.get_output_from_server
  num_of_cards = client.get_output_from_server.chomp.to_i
  num_of_cards.times do
    hand.push(client.get_output_from_server.chomp)
  end
  puts hand.join(', ')
  hand.each do |card|
    # Remove the Your Cards: from the first element
    if hand.index(card) == 0
      card.slice!(0, 12)
    end

    until card.length == 1
      card[-1] = ''
    end
    # Put the 0 back on to the ten
    if card[0] == "1"
      card << "0"
    end
  end
  if turn.chomp == player_num
    puts client.get_output_from_server.green
    request = client.prompt_for_input()
    # Checks if the client's response is valid
    until request.class == Request && request.target.downcase != client.name.downcase && hand.include?(request.rank)
        puts "That is not a valid response. Please try again. (Remember, must must ask for a card that you already have in your hand. You also have to do Player2 insted of Player 2)"
        request = client.prompt_for_input()
    end
    client.socket.puts(request.to_json)
    client.decipher(client.get_output_from_server)
  else
    puts "Waiting for the other players to complete their turn..."
    puts client.decipher(client.get_output_from_server)
  end

end
