=begin
  Класс Station (Станция):
    -Имеет название, которое указывается при ее создании
    -Может возвращать список всех поездов на станции, находящиеся в текущий момент
    -Может принимать поезда (по одному за раз)
    -Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
    -Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
=end

class Station
  attr_reader :name_station, :train

  def initialize(name_station)
    @name_station = name_station
    @train = []
  end

  def add_train(train)
    self.train << train
  end

  def send_train(train)
    self.train.delete(train)
  end

  def get_list_type_train(type)
    count = 0
    self.train.each do |train|
      if train.type_train == type
        count += 1
      end
    end
    count
  end

  def get_list_train
    self.train.size
  end

end