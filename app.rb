require 'sinatra'
require 'sinatra/reloader'

get('/static_page') do
  slim(:index)
end

get('/join') do
  "Waiting for other players... BE PATIENT!"
end
