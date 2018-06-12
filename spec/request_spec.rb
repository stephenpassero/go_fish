require 'rspec'
require 'pry'
require 'request'

describe "request" do
  let(:player1) {Player.new()}
  let(:player2) {Player.new()}
  let(:card) {Card.new(6, "Diamonds")}

  it "should have a card attribute" do
    request = Request.new(player1, card, player2)
    expect(request.card).to eq(card)
  end
  it "should have a player_requesting attribute" do
    request = Request.new(player1, card, player2)
    expect(request.player_requesting).to eq(player1)
  end
  it "should have a player_requesting_from attribute" do
    request = Request.new(player1, card, player2)
    expect(request.player_requesting_from).to eq(player2)
  end
end
