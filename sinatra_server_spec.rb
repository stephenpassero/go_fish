require 'capybara/rspec'
require 'sinatra'
require 'app.rb'

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe "app", {} do
  it 'should contain an input field' do

  end
end
