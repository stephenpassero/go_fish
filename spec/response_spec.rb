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
end
