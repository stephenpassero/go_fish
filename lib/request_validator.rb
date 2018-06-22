require 'pry'

class RequestValidator
  attr_reader(:game)
  def initialize(game)
    @game = game
  end

  # Split this up into multiple methods
  def validate(string, fisher, all_names)
    if string == ""
      return ["", ""]
    else
      regex = /ask\s(\w+).*\s(\w{2}|\w{1})/i
      matches = string.match(regex)
      if matches == nil
        return false
      end
      target = matches[1]
      card_rank = matches[2]
      player = game.find_player(fisher[-1].to_i) # Gets the actual player object
      if card_rank.to_i != 0 # Changes the card rank to an integer if it isn't a face card
        card_rank = card_rank.to_i
      end
      all_names.each do |name|
        name.downcase!
      end
      if target.downcase == fisher.downcase || player.card_in_hand(card_rank) == false || !all_names.include?(target)
        return false
      end
      return [target, card_rank]
    end
  end
end
