require 'rspec'
require 'player'
require 'card_deck'
require 'game'

describe "game" do
  it "creates a deck" do
    num_of_players = 1
    game = Game.new(1)
    expect(game.deck).not_to eq(nil)
  end

  it "should give the the number representing the player's turn" do
    num_of_players = 1
    game = Game.new(num_of_players)
    expect(game.get_player_turn).to eq(1)
    game.increment_player_turn
    expect(game.get_player_turn).to eq(2)
  end
end
