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

  def num_of_games()
    games_to_clients.length
  end

  def accept_new_client(player_name = "Random Player")
    sleep(0.1)
    client = server.accept_nonblock
    pending_clients.push(client)
    if pending_clients.length == num_of_players
      client.puts("Welcome! The the game will begin shortly. You are Player #{pending_clients.length}")
    else
      client.puts("Welcome! Waiting for other players to join... You are Player #{pending_clients.length}")
      if pending_clients.length == 1
        client.puts("How many people would you like to play with?")
        client_output = ""
        until client_output != ""
          client_output = capture_output(client)
          sleep(0.01)
        end
        # Use regex to get the number out of the client's output
        num = client_output[/\d/].to_i
        create_game_lobby(num)
      end
    end
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible()
    if pending_clients.length == num_of_players
      game = Game.new(num_of_players)
      games_to_clients.store(game, pending_clients.shift(num_of_players))
      return game
    end
  end

  def tell_clients_their_hand(game)
    clients = find_clients(game)
    clients.each do |client|
      client_num = clients.index(client)
      player = game.find_player(client_num + 1)
      player.deck.cards.each do |card|
        client.puts("Your cards: #{card.to_s}")
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

  def run_round(game)
    player_num = game.player_turn
    clients = find_clients(game)
    tell_clients_their_hand(game)
    current_client = clients[game.player_turn - 1]
    current_client.puts("Who would you like to ask for what?")
    current_client.puts("Example: Ask Player3 for a 9")
    response = ""
    until response != ""
      response = capture_output(current_client)
    end
    regex = /(player\d).*\s(\w+)$/
    matches = response.match(regex)
    target = matches[1]
    # get the actual TCPSocket of the target player
    target_client = clients[target[-1].to_i - 1]
    card_rank = matches[2]
    clients.each do |client|
      if client == current_client
        client.puts "You asked #{target} for a #{card_rank}"
      elsif client == target_client
        client.puts "Player#{player_num} asked you for a #{card_rank}"
      else
        client.puts "Player#{player_num} asked #{target} for a #{card_rank}"
      end
    end
    current_player = game.find_player(player_num)
    target_player = game.find_player(target[-1].to_i)
    game.run_round(current_player, card_rank, target_player)
  end

  def start_game(game)
    game.start_game()
    until game.winner()
      run_round(game)
    end
    clients = find_clients(game)
    clients.each do |client|
      client.puts("Game Over... Someone won, I have no idea who.")
    end
  end


  private
  attr_reader(:games_to_clients, :server, :num_of_players)

  def capture_output(desired_client, game=nil, delay=0.1)
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
