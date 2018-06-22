require 'socket'
require_relative 'request'
require_relative 'game'
require_relative 'response'
require_relative 'request'

class GoFishServer
  attr_reader(:pending_clients)
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

  def set_player_hand(game, player_num, arr_of_cards=[])
    player = game.find_player(player_num)
    player.set_deck(arr_of_cards)
  end

  def nums_of_clients_in_a_game(index_of_game)
    games_to_clients.values[index_of_game].length
  end

  def accept_new_client(player_name = "Random Player")
    client = server.accept_nonblock
    pending_clients.push(client)
    if pending_clients.length == num_of_players
      client.puts("Welcome! The the game will begin shortly. You are Player #{pending_clients.length}")
    else
      client.puts("Welcome! Waiting for other players to join... You are Player #{pending_clients.length}")
      if pending_clients.length == 1
        client_output = ""
        until client_output != "" && client_output != "1"
          client_output = capture_output(client)
        end
        # Use regex to get the number out of the client's output
        num = client_output[/\d/].to_i
        create_game_lobby(num)
      end
    end
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR

  end

  def create_game_if_possible()
    if pending_clients.length == num_of_players
      game = Game.new()
      num_of_players.times do |index|
        game.create_new_player("Player#{index + 1}")
      end
      games_to_clients.store(game, pending_clients.shift(num_of_players))
      return game
    end
  end

  def tell_clients_their_hand(game)
    clients = find_clients(game)
    clients.each do |client|
      client_num = clients.index(client)
      player = game.find_player(client_num + 1)
      client.print("Your cards: ")
      player.deck.cards.each.with_index do |card, index|
        client.puts("#{card.to_s}")
      end
    end
  end

  def find_game(game_id)
    games_to_clients.keys[game_id]
  end

  def stop
    server.close if server
  end

  def find_clients(game)
    games_to_clients[game]
  end


  def player_cards_left(game, player)
    game.player_cards_left(player)
  end

  def run_round(request, game)
    return game.run_round(request)
  end

  def run_game(game)
    game.start_game()
    clients = find_clients(game)
    until game.winner()
    # Puts the turn number and the number of cards left to each client
      clients.each do |client|
        client.puts(game.player_turn)
        client_num = games_to_clients[game].index(client) + 1
        player = game.find_player(client_num)
        client.puts(player.cards_left)
      end
      sleep(0.001)
      tell_clients_their_hand(game)
      client = clients[game.player_turn - 1]
      client.puts("It's your turn.")
      request = ""
      until request != ""
        request = capture_output(client)
      end
      response = run_round(request, game)
      if response.card == false
        game.increment_player_turn()
      end
      clients.each do |client|
        client.puts(response.to_json)
      end
    end
    # Gets the player number, like 3 or 1
    player_num = game.players.index(game.winner())
    clients.each do |client|
      client.puts("Game Over... Player#{player_num} won!")
    end
  end


  private
  attr_reader(:games_to_clients, :server, :num_of_players)

  def capture_output(desired_client, game=nil, delay=0.001)
    sleep(delay)
    output = ""
    if game
      client = games_to_clients[game][desired_client]
      output = client.read_nonblock(100)
    else
      output = desired_client.read_nonblock(100)
    end
  rescue IO::WaitReadable
    output = ""
  end
end
