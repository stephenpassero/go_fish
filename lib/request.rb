require 'pry'

class Request
  attr_reader(:player_requesting, :card, :player_requesting_from)

  def initialize(player_requesting, card, player_requesting_from)
    @player_requesting = player_requesting
    @card = card
    @player_requesting_from = player_requesting_from
  end
end
