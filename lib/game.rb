require 'pry'
require 'player'
require 'card_deck'
require 'response'

class Game
  attr_reader(:deck, :players)

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
    increment_player_turn()
    request_obj = Request.from_json(request)
    fisher = find_player(request_obj.fisher)
    target = find_player(request_obj.target)
    card_rank = request_obj.rank
    card = fisher.request_card(fisher, card_rank, target)
    fisher.pair_cards()
    if fisher.cards_left == 0
      refill_cards(fisher)
    elsif target.cards_left == 0
      refill_cards(target)
    end
    Response.new(fisher, card_rank, target, card.to_s).to_json
  end

  def start_game()
    deal_cards()
  end

  def cards_in_deck()
    deck.cards_left
  end

  def refill_cards(player)
    5.times do
      player.add_to_hand([deck.play_top_card])
    end
  end

  def get_player_turn()
    player_turn
  end

  def winner()
    running_winner = ''
    points = 0
    players.each do |player|
      if player.score > points
        running_winner = player
        points = player.score
      end
    end
    running_winner
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
