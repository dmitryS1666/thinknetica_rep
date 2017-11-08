load 'module/modules.rb'

class Carriage
  include CompanyModule

  attr_reader :number, :type

  def initialize(number)
    @number = number
    initial_type
  end

  def cargo?
    type == :cargo
  end

  def passenger?
    type == :passenger
  end

  protected

  attr_writer :type

  def initial_type
    @type = ''
  end
end
