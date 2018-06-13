require 'rspec'
require 'response'

describe "response" do
  let(:player1) {Player.new()}
  let(:player2) {Player.new()}
  let(:card) {Card.new(6, "Diamonds")}

  it "should have a card attribute" do
    response = Response.new(player1, card.rank, player2)
    expect(response.rank).to eq(card.rank)
  end
  it "should have a fisher attribute" do
    response = Response.new(player1, card.rank, player2)
    expect(response.fisher).to eq(player1)
  end
  it "should have a target attribute" do
    response = Response.new(player1, card.rank, player2)
    json_object = response.to_json
    new_response = Response.from_json(json_object)
    expect(response.target).to eq(player2)
  end

  it "should contain if the target has the card asked for" do
    card1 = Card.new(5, "Hearts")
    response = Response.new(player1, card.rank, player2, card1)
    expect(response.card).to eq(card1)
  end

  # it "should return a card object" do
  #   game = Game.new(2)
  #   player1 = game.find_player(1)
  #   player2 = game.find_player(2)
  #   card1 = Card.new(5, "Diamonds")
  #   card2 = Card.new(5, "Hearts")
  #   player1.set_hand(card1)
  #   player2.set_hand(card2)
  #   request = Request.new(1, card1.rank, 2).to_json
  #   response = game.run_round(request)
  #   new_response = Response.from_json(response)
  #
  #   expect(new_response.card).to eq("5-of-Hearts")
  # end
end
