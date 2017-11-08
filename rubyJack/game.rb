require_relative 'dealer'
require_relative 'player'
require_relative 'deck'

class Game
  attr_accessor :cards, :deck, :player, :dealer, :result, :bank, :game_table

  def initialize(name)
    @cards = []
    @deck = Deck.new
    @dealer = Dealer.new
    @game_table = true
    @player = Player.new(name)
  end

  def start_game
    @bank = 0
    @result = ''
    first_step
  end

  def first_step
    discard_card if !@dealer.cards.empty? || !@player.cards.empty?
    2.times { @dealer.give_card(@deck.deck) }
    @dealer.place_bet

    2.times { @player.give_card(@deck.deck) }
    @player.place_bet

    @bank += 20
  end

  def second_step(step)
    case step
      when 1
        pass
      when 2
        @player.give_card(@deck.deck)
      when 3
        @result = open_cards
        @game_table = false
    end
  end

  def pass
    puts 'Ход переходит к дилеру'
    @dealer.decision_making(@deck.deck)
  end

  def open_cards
    calculation_result
  end

  def calculation_result
    player_count = @player.amount_of_points
    dealer_count = @dealer.amount_of_points

    if (player_count > dealer_count || dealer_count > 21) && player_count <= 21
      @player.cash += @bank
      @bank = 0
      @player
    elsif (dealer_count > player_count || player_count > 21) && dealer_count <= 21
      @dealer.cash += @bank
      @bank = 0
      @dealer
    else
      nil
    end
  end

  def discard_card
    @dealer.cards = []
    @player.cards = []
  end

end

# gm = Game.new
# gm.count_amount(%w(A♢ 9♧ A♤))
# puts gm.amount_of_points
