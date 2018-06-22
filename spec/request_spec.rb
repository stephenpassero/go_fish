require 'rspec'
require 'pry'
require 'request'
require 'json'

describe "request" do
  let(:card) {Card.new(6, "Diamonds")}

  it "should have a card attribute" do
    request = Request.new(1, card.rank, 2)
    expect(request.rank).to eq(card.rank)
  end

  it "should have a fisher attribute" do
    request = Request.new(1, card.rank, 2)
    expect(request.fisher).to eq(1)
  end

  it "should have a target attribute" do
    request = Request.new(1, card.rank, 2)
    json_object = request.to_json
    new_request = Request.from_json(json_object)
    expect(request.fisher).to eq(1)
  end
end
