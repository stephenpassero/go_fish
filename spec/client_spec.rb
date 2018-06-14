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
    expect(client.decipher(response)).to eq("You asked for and took a J from Player2")
    server.stop
  end
end
