=begin
  Класс Train (Поезд):
    -Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
    -Может набирать скорость
    -Может возвращать текущую скорость (getter for speed)
    -Может тормозить (сбрасывать скорость до нуля)
    -Может возвращать количество вагонов (getter for count_rw_carriage)
    -Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
      -Прицепка/отцепка вагонов может осуществляться только если поезд не движется.

    -Может принимать маршрут следования (объект класса Route).
    -При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    -Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
    -Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end

class Train

  attr_accessor :speed, :route
  attr_reader :number_train, :count_rw_carriage, :type_train

  def initialize(speed = 0, number_train, type_train, count_rw_carriage)
    @speed = speed
    @number_train = number_train
    @type_train = type_train
    @count_rw_carriage = count_rw_carriage
  end

  def go(speed)
    self.speed += speed if speed > 0
  end

  def stop
    self.speed = 0
  end

  def attach_carriage
    self.count_rw_carriage += 1 if self.speed == 0
  end

  def unhook_carriage
    self.count_rw_carriage -= 1 if self.speed == 0 && self.count_rw_carriage > 0
  end

  def assign_route(route)
    self.route = route
    @current_station_index = 0
  end

  def current_station
    self.route.stations[@current_station_index]
  end

  def move_prev_station
    if @current_station_index > 0
      current_station.send_train(self.number_train)
      @current_station_index -= 1
      current_station.add_train(self.number_train)
    end
  end

  def move_next_station
    if @current_station_index < (self.route.stations.size - 1)
      current_station.send_train(self.number_train)
      @current_station_index += 1
      current_station.add_train(self.number_train)
    end
  end

  def get_prev_station
    self.route.stations[@current_station_index - 1] if @current_station_index > 0
  end

  def get_next_station
    self.route.stations[@current_station_index + 1] if @current_station_index < self.route.stations.size - 1
  end

end