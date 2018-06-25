require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require './lib/game'
require './lib/player'
require 'pusher'
require './lib/card_deck'
require './lib/request'
require './lib/request_validator'

@@game = Game.new()
@@players = []
@@names = []
@@counter = 0
@@responses = []
@@should_reload = false
class MyApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  def pusher_client()
    @pusher_client ||= Pusher::Client.new(
      app_id: '546993',
      key: 'a025ff2562d8f55637c7',
      secret: '294587b746ab86785395',
      cluster: 'us2'
    )
  end

  get('/') do
    slim(:join)
  end

  get('/waiting') do
    if @@players.length % 4 == 0
      # Only do this once
      if @@counter == 0
        @@game.deal_cards()
        pusher_client.trigger("go_fish", "game_is_starting", {message: "All players have joined."})
        @@counter += 1
      end
      redirect("/game?id=#{params["id"]}")
    else
      slim(:waiting)
    end
  end

  get('/game') do
    @last_four_names = @@names.last(4)
    @last_four_players = @@players.last(4)
    @names = @@names
    @players = @@players
    @player_turn = @@game.player_turn
    @responses = @@responses
    @cards_in_deck = @@game.cards_in_deck()
    @should_reload = @@should_reload
    slim(:index)
  end

  get('/game_over') do
    @game = @@game
    @deck = CardDeck.new()
    slim(:game_over)
  end

  post('/game') do
    if @@game.cards_left_in_play? == false
      pusher_client.trigger("go_fish", "game_over", {message: "The game has ended"})
    end
    request_validator = RequestValidator.new(@@game)
    string = params['request']
    current_player_name = @@names[params['id'].to_i - 1]
    arr = request_validator.validate(string, current_player_name, @@names)
    if arr == false
      @@should_reload = true
      redirect("/game?id=#{params['id'].to_i}")
    end
    target = arr[0]
    card_rank = arr[1]
    request = Request.new(current_player_name, card_rank, target)
    response = @@game.run_round(request.to_json)
    @@should_reload = false
    if response != ""
      if response.card == false
        @@responses.push("#{response.fisher} asked #{response.target} for a #{response.rank}. Go Fish!")
      else
        @@responses.push("#{response.fisher} took a #{response.rank} from #{response.target}")
      end
      if @@responses.length > 5
        @@responses.shift()
      end
    end
    pusher_client.trigger("go_fish", "game_changed", {message: "A player completed his turn"})
    redirect("/game?id=#{params['id'].to_i}")
  end

  post('/') do
    name = params["name"]
    @@names.push(name)
    player = @@game.create_new_player(name)
    @@players.push(player)
    player_num = @@players.length
    return redirect("/waiting?id=#{player_num}")
  end

rescue()
  server.stop
end
