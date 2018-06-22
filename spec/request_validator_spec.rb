require 'request_validator'
require 'game'
require 'card'

describe 'request_validator' do
  it 'should return if a request is valid or not' do
    game = Game.new()
    player1 = game.create_new_player("Player1")
    player2 = game.create_new_player("Player2")
    player1_name = player1.name
    player2_name = player2.name
    names = [player1_name, player2_name]
    card1 = Card.new("J", "Clubs")
    card2 = Card.new(2, "Diamonds")
    card3 = Card.new(7, "Diamonds")
    card4 = Card.new("J", "Hearts")
    player1.set_hand(card1, card2)
    player2.set_hand(card3, card4)
    request_validator = RequestValidator.new(game)
    expect(request_validator.validate("Ask player2 for a J", player1_name, names)).to eq(true)
    expect(request_validator.validate("Ask player1 for a 2", player1_name, names)).to eq(false)
    expect(request_validator.validate("Ask player2 for a 2", player1_name, names)).to eq(true)
    expect(request_validator.validate("Ask player2 for a 7", player1_name, names)).to eq(false)
  end
end
