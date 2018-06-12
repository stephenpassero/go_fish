class Response
  attr_reader(:player_requesting, :card, :player_requesting_from, :contains_card)

  def initialize(player_requesting, card, player_requesting_from, contains_card)
    @player_requesting = player_requesting
    @card = card
    @player_requesting_from = player_requesting_from
    @contains_card = contains_card
  end
end
