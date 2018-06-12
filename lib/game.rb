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

  def run_round(request)
    # puts "Would you like to take a card from a player or go fish?"
    increment_player_turn()
    request_obj = Request.from_json(request)
    fisher = find_player(request_obj.fisher)
    target = find_player(request_obj.target)
    card_rank = request_obj.rank
    fisher.request_card(fisher, card_rank, target)
  end

  def start_game()

    #run_round(find_player(get_player_turn()))
  end

  def cards_in_deck()
    deck.cards_left
  end

  def get_player_turn()
    player_turn
  end

  def set_player_hand(player_num, *cards)
    players[player_num - 1].set_hand(cards)
  end

  def find_player(player_num)
    players[player_num - 1]
  end

  def player_cards_left(player)
    player.cards_left
  end

  def increment_player_turn()
    if player_turn == players.length
      @player_turn = 1
    else
      @player_turn += 1
    end
  end
  private
  attr_reader(:players, :player_turn)
end
