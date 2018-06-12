require 'rspec'
require 'response'

describe "response" do
  let(:player1) {Player.new()}
  let(:player2) {Player.new()}
  let(:card) {Card.new(6, "Diamonds")}

  it "should have a card attribute" do
    response = Response.new(player1, card, player2, true)
    expect(response.card).to eq(card)
  end
  it "should have a player_requesting attribute" do
    response = Response.new(player1, card, player2, false)
    expect(response.player_requesting).to eq(player1)
  end
  it "should have a player_requesting_from attribute" do
    response = Response.new(player1, card, player2, true)
    expect(response.player_requesting_from).to eq(player2)
  end

  it "should contain if the player_requesting_from has the card asked for" do
    response = Response.new(player1, card, player2, true)
    expect(response.contains_card).not_to eq(nil)
  end
end
