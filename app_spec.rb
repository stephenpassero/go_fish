require 'capybara/rspec'
require 'sinatra'
require 'rack/test'
require 'pry'
require_relative 'app.rb'

Capybara.app = MyApp.new()

describe "app", {:type => :feature} do
  it 'should have a main page' do
    visit('/')
    expect(page).to have_content("Welcome to Go Fish!")
  end

  it 'after the first page should go to a waiting page' do
    visit('/')
    fill_in('num_of_players', :with => '5')
    click_on('submit')
    expect(page).to have_content("Waiting for other players...")
  end

  it 'after the waiting page it should go to the game page' do
    session1 = Capybara::Session.new(:rack_test, MyApp.new)
    session2 = Capybara::Session.new(:rack_test, MyApp.new)
    session3 = Capybara::Session.new(:rack_test, MyApp.new)
    [session1, session2, session3].each do |session|
      session.visit('/')
      session.fill_in('num_of_players', :with => '3')
      session.click_on("submit")
    end
    expect(session2).to have_content("Player2")
  end
end
