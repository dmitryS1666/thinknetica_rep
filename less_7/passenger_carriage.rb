class PassengerCarriage < Carriage
  attr_accessor :number_seats, :number_free_seats

  def initialize(number_seats)
    super
    @number_seats = number_seats
    @number_free_seats = number_seats
  end

  def occupied_seats
    @number_seats - @number_free_seats
  end

  def occupy_seats
    @number_free_seats -= 1 if @number_free_seats > 0
  end

  def free_space
    @number_free_seats += 1 if @number_free_seats <= @number_seats
  end

  protected

  def initial_type
    @type = 'passenger'
  end
end
