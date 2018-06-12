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
    num_of_players = 2
    game = Game.new(num_of_players)
    expect(game.get_player_turn).to eq(1)
    game.increment_player_turn
    expect(game.get_player_turn).to eq(2)
  end

  it "#run_game should distribute five cards to each player" do
    # The number 4 is how many players are being created
    game = Game.new(4)
    game.start_game()
    # Give five cards to each player. 5 x 4 = 20. A full deck, 52 cards, minus 20 cards = 32
    expect(game.cards_in_deck).to eq(32)
  end

  describe "#run_round" do

  end
end
