require 'socket'
require_relative 'server'

server = GoFishServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  # if game
  #   Thread.new {server.run_game(game)}
  # end
end
