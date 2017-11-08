require_relative 'module/instance_counter'
require_relative 'module/validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains
  @@instances = []

  def self.all
    @@instances
  end

  validate :name, :presence

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@instances << self
    register_instance
  end

  def each_train
    @trains.each { |tr| yield(tr) }
  end

  def add_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def get_list_type_train(type)
    count = 0
    trains.each do |train|
      count += 1 if train.type_train == type
    end
    count
  end

  def list_train
    trains.size
  end

end
