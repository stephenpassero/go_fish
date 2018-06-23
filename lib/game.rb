require 'pry'
require_relative 'player'
require_relative 'card_deck'
require_relative 'response'

class Game
  attr_reader(:deck, :players, :player_turn)

  def initialize()
    @players = {}
    @player_turn = 1
    @deck = CardDeck.new()
    @deck.shuffle!
  end

  def deal_cards()
    5.times do
      players.values.each do |player|
        player.add_to_hand([deck.play_top_card])
      end
    end
  end

  def set_cards(arr_of_cards=[])
    deck.set_cards(arr_of_cards)
  end

  def run_round(request)
    new_request = Request.from_json(request)
    if new_request.rank == ""
      increment_player_turn()
      return ""
    else
      original_fisher = new_request.fisher.downcase
      original_target = new_request.target.downcase
      #Find the actual player objects
      fisher = players[new_request.fisher.downcase]
      target = players[new_request.target.downcase]
      card_rank = new_request.rank
      if card_rank.to_i == 0 # Checks if the card is a face card
        card = fisher.request_card(fisher, card_rank, target)
      else
        card = fisher.request_card(fisher, card_rank.to_i, target)
      end
      if card == false
        if deck.cards_left >= 1
          fisher.add_to_hand([deck.play_top_card()])
        end
        increment_player_turn()
      end
      fisher.pair_cards()
      if fisher.cards_left == 0
        refill_cards(fisher)
      elsif target.cards_left == 0
        refill_cards(target)
      end
      return Response.new(original_fisher, card_rank, original_target, card)
    end
  end

  def start_game()
    deal_cards()
  end

  def create_new_player(player_name)
    player = Player.new(player_name)
    players[player_name.downcase] = player
    player
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
      players.values.each do |player|
        if player.score > points
          running_winner = player
          points = player.score
        end
      end
    end
    running_winner
  end

  def cards_left_in_play?()
    players_out_of_cards = false
    players.values.each do |player|
      if player.cards_left > 0
        players_out_of_cards = true
      end
    end
    players_out_of_cards
  end

  def set_player_hand(player_num, *cards)
    players[player_num - 1].set_hand(cards)
  end

  def find_player(player_num)
    @players.values[player_num - 1]
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
