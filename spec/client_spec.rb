require 'rspec'
require 'response'
require 'request'
require 'client'
require 'card'
require 'server'
describe "client" do

  it "should be able to decipher a json response" do
    server = GoFishServer.new()
    server.start
    client = Client.new("Player1")
    client2 = Client.new("Player2")
    card = Card.new("J", "Spades")
    response = Response.new("Player1", card.rank, "Player2", card).to_json
    expect(client.decipher(response)).to include("You asked Player2 for a J")
    expect(client2.decipher(response)).to include("Player1 asked you for a J")
    server.stop
  end

  it "should be able to convert the name of a card" do
    client = Client.new("Player1")
    expect(client.convert_card("7-of-clubs")).to eq("c7")
    expect(client.convert_card("J-of-Diamonds")).to eq("dj")
  end
end
