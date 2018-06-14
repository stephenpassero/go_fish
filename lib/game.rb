require 'pry'
require_relative 'player'
require_relative 'card_deck'
require_relative 'response'

class Game
  attr_reader(:deck, :players, :player_turn)

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

  def set_cards(arr_of_cards=[])
    deck.set_cards(arr_of_cards)
  end

  def run_round(request)
    new_request = Request.from_json(request)
    original_fisher = new_request.fisher
    original_target = new_request.target
    #Find the actual player objects
    fisher = players[new_request.fisher[-1].to_i - 1]
    target = players[new_request.target[-1].to_i - 1]

    card_rank = new_request.rank
    increment_player_turn()
    card = fisher.request_card(fisher, card_rank, target)
    fisher.pair_cards()
    if fisher.cards_left == 0
      refill_cards(fisher)
    elsif target.cards_left == 0
      refill_cards(target)
    end
    return Response.new(original_fisher, card_rank, original_target, card).to_json
  end

  def start_game()
    deal_cards()
  end

  def cards_in_deck()
    deck.cards_left
  end

  def refill_cards(player)
    if deck.cards_left >= 5
      5.times do
        player.add_to_hand([deck.play_top_card])
      end
    end
  end

  def winner()
    running_winner = nil
    if deck.cards_left == 0 && cards_left_in_play? == false
      points = 0
      players.each do |player|
        if player.score > points
          running_winner = player
          points = player.score
        end
      end
    end
    running_winner
  end

  def cards_left_in_play?()
    players_out_of_cards = true
    players.each do |player|
      if player.cards_left == 0
        players_out_of_cards = false
      end
    end
    players_out_of_cards
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
end
