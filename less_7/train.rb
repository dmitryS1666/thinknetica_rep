require_relative 'module/modules'
require_relative 'module/instance_counter'
require_relative 'module/validation'

class Train
  include CompanyModule
  include InstanceCounter
  include Validation

  attr_accessor :speed, :route
  attr_reader :number_train, :carriages, :type_train

  NUMBER_REGEXP = /^[a-z]{3}-?[a-z|0-9]{2}$/i

  validate :number_train, :presence
  validate :number_train, :format, NUMBER_REGEXP

  @@instances = {}

  def initialize(number_train)
    @speed = 0
    @number_train = number_train
    validate!
    @carriages = []
    initial_type_train
    @@instances[number_train] = self
    register_instance
  end

  def each_carriage
    @carriages.each { |carriage| yield(carriage) }
  end

  def self.find(number)
    @@instances[number]
  end

  def go(speed)
    self.speed += speed if speed > 0
  end

  def stop
    self.speed = 0
  end

  def attach_carriage(carriage)
    carriages << carriage if train_stopped? && can_attach?(carriage)
  end

  def unhook_carriage(carriage)
    carriages.delete(carriage) if train_stopped? && carriages.empty? && can_attach?(carriage)
  end

  def train_stopped?
    self.speed.zero?
  end

  def assign_route(route)
    self.route = route
    self.route.stations[0].add_train(self)
    @current_station_index = 0
  end

  def current_station
    route.stations[@current_station_index]
  end

  def move_prev_station
    return unless @current_station_index > 0
    current_station.send_train(number_train)
    @current_station_index -= 1
    current_station.add_train(number_train)
  end

  def move_next_station
    return unless @current_station_index < route.stations.size - 1
    current_station.send_train(number_train)
    @current_station_index += 1
    current_station.add_train(number_train)
  end

  def prev_station
    pr_station if @current_station_index > 0
  end

  def next_station
    nt_station if @current_station_index < route.stations.size - 1
  end

  protected

  attr_writer :type_train, :carriages

  def initial_type_train
    @type_train = ''
  end

  def pr_station
    route.stations[@current_station_index - 1]
  end

  def nt_station
    route.stations[@current_station_index + 1]
  end

  def can_attach?(carriage)
    type_train == carriage.type
  end
end
