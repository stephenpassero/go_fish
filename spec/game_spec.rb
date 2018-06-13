require 'rspec'
require 'player'
require 'card_deck'
require 'game'
require 'request'
require 'response'

describe "game" do
  it "creates a deck" do
    num_of_players = 1
    game = Game.new(1)
    expect(game.deck).not_to eq(nil)
  end

  it "should give the the number representing the player's turn" do
    num_of_players = 2
    game = Game.new(num_of_players)
    expect(game.player_turn).to eq(1)
    game.increment_player_turn
    expect(game.player_turn).to eq(2)
  end

  it "#run_game should be able to distribute five cards to each player" do
    # The number 4 is how many players are being created
    game = Game.new(4)
    # Give five cards to each player. 5 x 4 = 20. A full deck, 52 cards, minus 20 cards = 32
    game.deal_cards()
    expect(game.cards_in_deck).to eq(32)
  end

  let(:game) {Game.new(2)}
  let(:player1) {game.find_player(1)}
  let(:player2) {game.find_player(2)}
  let(:card1) {Card.new(5, "Hearts")}
  let(:card2) {Card.new(5, "Spades")}
  let(:card3) {Card.new(5, "Diamonds")}
  let(:card4) {Card.new(5, "Clubs")}

  # it "should run a round and return a response object" do
  #   player1.set_hand(card1, card2)
  #   player2.set_hand(card3, card4)
  #   player1_num = 1
  #   player2_num = 2
  #   card_num = 5
  #   request = Request.new(player1_num, card_num, player2_num).to_json
  #   expect(game.run_round(request).class).to eq(String)
  # end

  it "refills the player's cards" do
    player1.set_hand(card1, card2, card3)
    player2.set_hand(card4)
    card_num = 5
    game.run_round(player1, card_num, player2)
    expect(player1.cards_left).to eq(5)
  end

  it "#run_round should check if a player has pairs" do
    player1.set_hand(card1, card2, card3)
    player2.set_hand(card4)
    card_num = 5
    game.run_round(player1, card_num, player2)
    expect(player1.score).to eq(1)
  end

  it "should be able to determine a winner" do
    player1.set_score(3)
    player2.set_score(5)
    game.set_cards([])
    expect(game.winner()).to eq(player2)
  end

  it "shouldn't determine a winner unless there are no cards left" do
    player1.set_score(3)
    player2.set_score(5)
    expect(game.winner()).to eq(nil)
  end
end
