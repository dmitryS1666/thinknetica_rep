require_relative 'hand'

class Player < Hand
  attr_accessor :name

  def initialize(name)
    super()
    @name = name
  end

end
