require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require './lib/game'
require './lib/player'
require 'pusher'
require './lib/request'

@@game = Game.new()
@@players = []
@@names = []
@@counter = 0
@@responses = []
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
    # Change this to accomodate for more than 1 game
    if @@players.length == 4
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
    @names = @@names
    @players = @@players
    @player_turn = @@game.player_turn
    @responses = @@responses
    slim(:index)
  end

  post('/game') do
    regex = /ask\s(\w+).*\s(\w{2}|\w{1})/i
    string = params['request']
    name = @@names[params['id'].to_i - 1]
    matches = string.match(regex)
    target = matches[1]
    card_rank = matches[2]
    request = Request.new(name, card_rank, target)
    response = @@game.run_round(request.to_json)
    if response.card == false
      @@responses.push("#{response.fisher} asked #{response.target} for a #{response.rank}")
    else
      @@responses.push("#{response.fisher} took a #{response.rank} from #{response.target}")
    end
    if @@responses.length > 5
      @@responses.shift()
    end
    pusher_client.trigger("go_fish", "game_changed", {message: "A player completed his turn"})
    redirect("/game?id=#{params['id'].to_i}")
  end

  post('/') do
    name = params["name"]
    @@names.push(name)
    player = @@game.create_new_player(name)
    @@players.push(player)
    # Will need to change the player num to allow for multiple games
    player_num = @@players.length
    return redirect("/waiting?id=#{player_num}")
  end

rescue()
  server.stop
end
