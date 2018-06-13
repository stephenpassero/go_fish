require("rspec")
require_relative("../lib/card_deck")
require_relative("../lib/card")
require("pry")

describe("card_deck") do

  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end

  it("should be able to shuffle the deck") do
    deck = CardDeck.new()
    original_cards = deck.cards.clone
    deck.shuffle!()
    expect(deck.cards).not_to eq(original_cards)
  end

  it("should be able to create a new deck using an existing array") do
    card1 = Card.new("A", "Hearts")
    card2 = Card.new(4, "Diamonds")
    card3 = Card.new(9, "Spades")
    deck = CardDeck.new([card1, card2, card3])
    expect(deck.cards()).to eq([card1, card2, card3])
  end

  it("should be able to add cards to the deck") do
    deck = CardDeck.new()
    card1 = Card.new("J", "Spades")
    deck.add([card1])
    expect(deck.cards_left()).to eq(53)
  end

  describe("#play_top_card") do
    it("should return the top card of the deck") do
      card_rank = 2
      deck = CardDeck.new()
      top_card = deck.play_top_card()
      expect(top_card.rank).to eq(card_rank)
    end

    it("should remove the card played from the deck") do
      deck = CardDeck.new()
      deck.play_top_card()
      expect(deck.cards_left()).to eq(51)
    end
  end
end
