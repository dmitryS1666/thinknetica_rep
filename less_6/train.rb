load 'module/modules.rb'
load 'module/instance_counter.rb'
# load 'module/validate.rb'

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
  include CompanyModule
  include InstanceCounter
  # include Validate

  attr_accessor :speed, :route
  attr_reader :number_train, :carriages, :type_train

  # три буквы или цифры в любом порядке,
  # необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса
  TYPE_TRAIN = /^(cargo|passenger)$/i
  NUMBER_TRAIN = /^[a-z]{3}-?[a-z|0-9]{2}$/i

  @@instances = {}

  def initialize(number_train)
    @speed = 0
    @number_train = number_train
    @carriages = []
    # @type_train = type_train
    initial_type_train
    @@instances[number_train] = self
    register_instance
    # validate?(@type_train, TYPE_TRAIN)
    validate?(number_train, NUMBER_TRAIN)
  end

  def validate?(param, regexp)
    validate!(param, regexp)
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

  def validate!(param, regexp)
    raise ArgumentError, "Необходимо вводить в формате #{regexp}" if param !~ regexp
    # raise ArgumentError, 'Поле не может быть пустым' if param.to_s.empty?
    # raise ArgumentError, 'Поле не может быть меньше 3 символов' if param.length < 3
    true
  end

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
    self.type_train == carriage.type_carriage
  end



end