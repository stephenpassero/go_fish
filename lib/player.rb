require_relative("./card_deck")
require("pry")

class Player
  attr_reader(:discard_pile)
  attr_accessor(:deck)

  def initialize()
    @deck = CardDeck.new([]);
    @discard_pile = []
  end

  def play_top_card()
    deck.play_top_card
  end

  def remove_card(card)
    deck.delete(card)
  end

  def add_to_hand(arr_of_cards)
    deck.add(arr_of_cards)
  end

  def card_in_hand(card_rank)
    deck.cards.each do |card_in_deck|
      if card_rank == card_in_deck.rank
        return card_in_deck
      end
    end
    return false
  end

  def set_hand(*cards)
    self.deck = CardDeck.new(cards)
  end

  def cards_left
    deck.cards_left
  end

  def request_card(player, card_rank, target)
    card = target.card_in_hand(card_rank)
    if card
      target.remove_card(card)
      player.add_to_hand([card])
      return true
    end
    return false
  end
end
