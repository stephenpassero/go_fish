require 'socket'
require 'request'
require_relative 'game'
require('pry')

class GoFishServer

  def initialize
    @pending_clients = []
    @games_to_clients = {}
  end

  def port_number
    3001
  end

  def games_to_clients
    games_to_clients
  end

  def create_game_lobby(num_of_players)
    @num_of_players = num_of_players
  end

  def start
    @server = TCPServer.new(3001)
  end

  def nums_of_clients_in_a_game(index_of_game)
    games_to_clients.values[index_of_game].length
  end

  def num_of_games()
    games_to_clients.length
  end

  def accept_new_client(player_name = "Random Player")
    sleep(0.1)
    client = server.accept_nonblock
    pending_clients.push(client)
    if pending_clients.length == num_of_players
      client.puts("Welcome! The the game will begin shortly.")
    else
      client.puts("Welcome! Waiting for other players to join...")
    end
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible()
    if pending_clients.length == num_of_players
      game = Game.new()
      games_to_clients.store(game, pending_clients.shift(num_of_players))
      game.start_game()
      return game
    end
  end

  def find_game(game_id)
    games_to_clients.keys[game_id]
  end

  def stop
    server.close if server
  end

  def player_cards_left(game, player)
    game.player_cards_left(player)
  end

  def run_round(game)
    result = game.start_run()
  end

  def run_game(game)
    game.start_game()
  end


  private
  attr_reader(:games_to_clients, :pending_clients, :server, :num_of_players)

  def capture_output(game, desired_client, delay=0.1)
    sleep(delay)
    output = ""
    client = games_to_clients[game][desired_client]
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = ""
  end
end
