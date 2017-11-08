=begin
  Класс Train (Поезд):
    -Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
    -Может набирать скорость
    -Может возвращать текущую скорость
    -Может тормозить (сбрасывать скорость до нуля)
    -Может возвращать количество вагонов (getter for count_carriage)
    -Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
      -Прицепка/отцепка вагонов может осуществляться только если поезд не движется.

    -Может принимать маршрут следования (объект класса Route).
    -При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    -Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
    -Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end


class Train
  attr_accessor :speed, :route
  attr_reader :number_train, :carriages, :type_train

  def initialize(number_train)
    @speed = 0
    @number_train = number_train
    @carriages = []
    initial_type_train
  end

  def go(speed)
    self.speed += speed if speed > 0
  end

  def stop
    self.speed = 0
  end

  def attach_carriage(carriage)
    self.carriages << carriage if train_stopped? && can_attach?(carriage)
  end

  def unhook_carriage(carriage)
    self.carriages.delete(carriage) if train_stopped? && self.carriages.size > 0 && can_attach?(carriage)
  end

  def train_stopped?
    self.speed.zero?
  end

  def assign_route(route)
    self.route = route
    self.route.stations[0].add_train(@number_train)
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
    prev_station if @current_station_index > 0
  end

  def get_next_station
    next_station if @current_station_index < self.route.stations.size - 1
  end

  protected

  attr_writer :type_train
  # инициализация типа поезда не может быть изменена из вне
  # по дефолту тип поезда - пустое значение
  def initial_type_train
    @type_train = ''
  end

  # добавил данные методы для улучшения читабельности кода
  # вынес в данную секцию, т.к. их нельзя вызывать без проверки условий
  def prev_station
    self.route.stations[@current_station_index - 1]
  end

  def next_station
    self.route.stations[@current_station_index + 1]
  end

  def can_attach?(carriage)
    carriage.type_carriage == type_train
  end

end