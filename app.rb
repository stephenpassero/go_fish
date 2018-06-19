require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require './lib/server.rb'
require './lib/client.rb'
Thread.new{require_relative './lib/go_fish_runner.rb'}
$clients = []
class MyApp < Sinatra::Base

  get('/') do
    slim(:join)
  end

  get('/waiting') do
    if $clients.length == $num_of_players.to_i
      redirect("/game?client_number=#{$player_num}")
    else
      slim(:waiting)
    end
  end

  post('/waiting') do
    redirect("/game")
  end

  get('/game') do
    @num_of_players = $num_of_players
    slim(:index)
  end

  post('/') do
    @num_of_players = params["num_of_players"]
    $num_of_players = @num_of_players
    $client = Client.new("Player1")
    text = $client.get_output_from_server
    player_num = text.chomp[-1]
    $player_num = player_num
    $client.name = "Player#{player_num}"
    $clients.push($client)
    if player_num == "1"
      $client.socket.puts(@num_of_players)
    end
    return redirect("/waiting?client_number=#{player_num}")
  end

rescue()
  server.stop
end
