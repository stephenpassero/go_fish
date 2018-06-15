require_relative 'client'
require_relative 'server'
require_relative 'request'

client = Client.new("Player1")

text = client.get_output_from_server
player_num = text.chomp[-1]
client.name = "Player#{player_num}"
puts text
# Rename get_output to get input
if player_num == "1"
  puts client.get_output_from_server
  client.get_output
  puts client.get_output_from_server
end

loop do
  turn = client.get_output_from_server
  num_of_cards = client.get_output_from_server.chomp.to_i
  num_of_cards.times do
    puts client.get_output_from_server
  end
  if turn.chomp == player_num
    puts client.get_output_from_server
    request = client.prompt_for_input()
    until request.class == Request
      puts "That is not a valid response. Please try again."
      request = client.prompt_for_input()
    end
    client.socket.puts(request.to_json)
    puts client.decipher(client.get_output_from_server)
  else
    puts "Waiting for the other players to complete their turn..."
    puts client.decipher(client.get_output_from_server)
  end
end
