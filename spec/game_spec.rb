require 'rspec'
require 'player'
require 'card_deck'
require 'game'
require 'request'

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
    game.deal_cards()
    expect(game.cards_in_deck).to eq(32)
  end

  it "should run a round and return a response object" do
    game = Game.new(3)
    player1 = game.find_player(1)
    player2 = game.find_player(1)
    card1 = Card.new(3, "Spades")
    card2 = Card.new('A', "Hearts")
    card3 = Card.new('J', "Clubs")
    card4 = Card.new(6, "Diamonds")
    player1.set_hand(card1, card2)
    player2.set_hand(card3, card4)
    request = Request.new(1, 3, 2).to_json
    expect(game.run_round(request)).to eq(false)
  end
end
