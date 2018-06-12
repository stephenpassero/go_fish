require("rspec")
require_relative("../lib/card")

describe("card") do

  describe("#rank") do
    it("returns the rank of the card") do
      card_rank = "J"
      card = Card.new(card_rank, "")
      expect(card.rank()).to eq("J")
    end
  end

  describe("#suit") do
    it("returns the suit of the card") do
      card_suit = "Spades"
      card = Card.new("", card_suit)
      expect(card.suit()).to eq("Spades")
    end
  end
end
