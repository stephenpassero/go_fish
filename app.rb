require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require './lib/server.rb'
require './lib/client.rb'

Thread.new{require_relative './lib/go_fish_runner.rb'}
@@clients = []
@@names = []
@@counter = 0;
class MyApp < Sinatra::Base

  get('/') do
    slim(:join)
  end

  get('/waiting') do
    if @@clients.length % 4 == 0
      redirect("/game?id=#{params["id"]}")
    else
      slim(:waiting)
    end
  end

  get('/game') do
    @names = @@names
    @clients = @@clients
    slim(:index)
  end

  post('/') do
    name = params["name"]
    @@names.push(name)
    client = Client.new("Player1")
    text = client.get_output_from_server
    player_num = text.chomp[-1]
    client.name = "Player#{player_num}"
    # Set client to a local variable
    @@clients.push(client)
    if player_num == "1"
      client.socket.puts(4)
    end
    return redirect("/waiting?id=#{player_num}")
  end

rescue()
  server.stop
end
