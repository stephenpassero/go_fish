require 'capybara/rspec'
require 'sinatra'
require_relative 'app.rb'

Capybara.app = Sinatra::Application

describe "app", {:type => :feature} do
  it 'should have a main page' do
    visit('/')
    expect(page).to have_content("Welcome to Go Fish!")
  end

  it 'go to a different page' do
    visit('/')
    fill_in('num_of_players', :with => '5')
    click_button('Submit')
    expect(page).to have_content("Player5")
  end
end
