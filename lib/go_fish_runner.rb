require 'socket'
require_relative 'server'

server = GoFishServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  sleep(1)
  if game
    server.run_game(game)
  end
end
