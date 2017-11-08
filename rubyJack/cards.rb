class Cards
  attr_reader :card, :rating

  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
  HIGH_RATINGS = {'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11}
  SUITS = %W(\u2664 \u2661 \u2667 \u2662)

  def initialize(rating, suit)
    validate(rating, suit)
    @card = rating.to_s + suit
    @rating = HIGH_RATINGS[rating] || rating
  end

  def validate(rating, suit)
    raise 'Wrong card type' unless CARDS.include?(rating) #&& SUITS.include?(suit.decode('utf-8'))
  end
end
