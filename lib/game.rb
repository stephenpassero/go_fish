require 'pry'
require 'player'
require 'card_deck'

class Game
  attr_reader(:deck)

  def initialize(num_of_players)
    @players = []
    num_of_players.times do
      @players.push(Player.new())
    end
    @player_turn = 1
    @deck = CardDeck.new()
    @deck.shuffle!
  end

  def deal_cards()
    5.times do
      players.each do |player|
        player.add_to_hand([deck.play_top_card])
      end
    end
  end

  # To-Do: Add a run game and run round method. Remember to use TDD!
  def run_round(player)
    puts "Would you like to take a card from a player or go fish?"
    increment_player_turn
  end

  def start_game()
    deal_cards()
    run_round(find_player(get_player_turn()))
  end

  def cards_in_deck()
    deck.cards_left
  end

  def get_player_turn()
    player_turn
  end

  def find_player(player_num)
    players[player_num - 1]
  end

  def player_cards_left(player)
    player.cards_left
  end

  def increment_player_turn()
    @player_turn += 1
  end
  private
  attr_reader(:players, :player_turn)
end
