require 'sinatra'
require 'sinatra/reloader'

get('/') do
  slim(:index)
end

get('/join') do
  "Waiting for other players... BE PATIENT!"
end
