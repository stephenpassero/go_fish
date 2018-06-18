require 'sinatra'
require 'sinatra/reloader'
require 'pry'

get('/') do
  slim(:join)
end

post('/') do
  @num_of_players = params["num_of_players"]
  slim(:index)
end
