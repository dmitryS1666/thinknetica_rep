require_relative 'hand'

class Dealer < Hand

  def decision_making(cards)
    if self.amount_of_points < 18
      self.give_card(cards)
    end
  end

end
