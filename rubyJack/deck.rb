require_relative 'cards'

class Deck
  attr_accessor :deck

  def initialize
    @deck = create_deck
  end

  def create_deck
    deck = []

    Cards::SUITS.each do |suit|
      Cards::CARDS.each do |rating|
        deck << Cards.new(rating, suit.encode('utf-8'))
      end
    end
    deck.shuffle!.reverse!.shuffle!.reverse!.shuffle!
  end
end

# puts Deck.new.deck.to_s
