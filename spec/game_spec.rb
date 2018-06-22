require 'rspec'
require 'player'
require 'card_deck'
require 'game'
require 'request'
require 'response'

describe "game" do
  it "creates a deck" do
    game = Game.new()
    game.create_new_player("Player1")
    expect(game.deck).not_to eq(nil)
  end

  it "should give the the number representing the player's turn" do
    game = Game.new()
    2.times do |index|
      game.create_new_player("Player#{index + 1}")
    end
    expect(game.player_turn).to eq(1)
    game.increment_player_turn
    expect(game.player_turn).to eq(2)
  end

  it "#run_game should be able to distribute five cards to each player" do
    game = Game.new()
    4.times do |index|
      game.create_new_player("Player#{index + 1}")
    end
    # Give five cards to each player. 5 x 4 = 20. A full deck, 52 cards, minus 20 cards = 32
    game.deal_cards()
    expect(game.cards_in_deck).to eq(32)
  end

  let(:game) {Game.new()}
  let(:card1) {Card.new(5, "Hearts")}
  let(:card2) {Card.new(5, "Spades")}
  let(:card3) {Card.new(5, "Diamonds")}
  let(:card4) {Card.new(5, "Clubs")}
  before :each do
    2.times do |index|
      game.create_new_player("Player#{index + 1}")
    end
  end
  let(:player1) {game.find_player(1)}
  let(:player2) {game.find_player(2)}
  it "should run a round and return a json response object" do
    player1.set_hand(card1, card2)
    player2.set_hand(card3, card4)
    player1_num = 1
    player2_num = 2
    card_num = 5
    request = Request.new("Player1", card_num, "Player2").to_json
    expect(game.run_round(request).class).to eq(Response)
  end

  it "refills the player's cards" do
    player1.set_hand(card1, card2, card3)
    player2.set_hand(card4)
    card_num = 5
    request = Request.new("Player1", card_num, "Player2").to_json
    game.run_round(request)
    expect(player1.cards_left).to eq(5)
  end

  it "#run_round should check if a player has pairs" do
    player1.set_hand(card1, card2, card3)
    player2.set_hand(card4)
    card_rank = 5
    request = Request.new("Player1", card_rank, "Player2").to_json
    game.run_round(request)
    # Expect player1's score to be incremented by one
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
