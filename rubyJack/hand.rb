class Hand
  attr_accessor :cards, :amount_of_points, :cash

  def initialize
    @cards = []
    @amount_of_points = 0
    @cash = 100
  end

  def give_card(deck)
    @cards << deck.shift
    count_amount
  end

  def count_amount
    @amount_of_points = 0
    @cards.each do |card|
      @amount_of_points += card.rating.to_i
    end
  end

  def place_bet
    @cash -= 10 if @cash > 10
  end

  def card_added?
    @cards.size == 2
  end

  def hand_full?
    @cards.size == 3
  end

end