require("rspec")
require_relative("../lib/player")

describe("#player") do
  it("should have a deck of cards") do
    player = Player.new()
    expect(player.deck).not_to eq(nil)
  end

  it "should give its card to the other player who asked for it" do
    player1 = Player.new()
    player2 = Player.new()
    card1 = Card.new("A", "Clubs")
    card2 = Card.new(4, "Hearts")
    card3 = Card.new(7, "Spades")
    card4 = Card.new(4, "Spades")
    player1.set_hand(card1, card2)
    player2.set_hand(card3, card4)
    player2.request_card(player1, 4, player2)
    expect(player2.cards_left).to eq(1)
  end

end
