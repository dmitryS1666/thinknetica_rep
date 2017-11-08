class Carriage

  attr_reader :number_carriage, :type_carriage

  def initialize(number_carriage)
    @number_carriage = number_carriage
    initial_type_carriage
  end

  protected

  attr_writer :type_carriage

  def initial_type_carriage
    @type_carriage = ''
  end

end