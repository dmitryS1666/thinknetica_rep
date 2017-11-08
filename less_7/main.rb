require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

class Main
  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def menu
    loop do
      puts 'Выберите один из пунктов меню - указав индекс меню:
        1. Создать станцию
        2. Создать поезд
        3. Создать маршрут
        3.1. Добавить промежуточную станцию к маршруту
        3.2. Удалить промежуточную станцию из маршруту
        4. Назначить маршрут для поезда
        5. Добавить вагон к поезду
        6. Отцепить вагон от поезда
        7. Переместить поезд вперед
        8. Переместить поезд назад
        9. Просмотреть список станций
        10. Просмотреть список поездов на станции
        11. Просмотреть список вагонов у поезда
        12. Занимать место или объем в вагоне
        0. Выход' << "\n"

      menu_index = gets.chomp.to_f
      case menu_index
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 3.1
        add_mid_station
      when 3.2
        delete_mid_station
      when 4
        assign_route
      when 5
        attach_carriage
      when 6
        unhook_carriage
      when 7
        move_train_next_station
      when 8
        move_train_prev_station
      when 9
        all_stations
      when 10
        trains_by_station
      when 11
        carriages_by_train
      when 12
        occupy_space_or_volume
      when 0
        break
      end
    end
  end

  private

  attr_accessor :stations, :trains, :routes

  def create_station
    puts 'Укажите имя станции:'
    name = gets.chomp.to_s
    @stations << Station.new(name)
  rescue ArgumentError => e
    puts e
    retry
    puts @stations
  end

  def create_train
    puts 'Укажите тип поезда (cargo/passenger)'
    tp_train = gets.chomp.to_s
    puts 'Укажите номер поезда'
    number_train = gets.chomp.to_s

    if tp_train == 'passenger'
      @trains << PassengerTrain.new(number_train)
    elsif tp_train == 'cargo'
      @trains << CargoTrain.new(number_train)
    end
    puts @trains.to_s
  rescue ArgumentError => e
    puts e
    retry
  end

  def create_route
    station_list
    puts 'Выберите индекс станции из списка для начальной станции'
    start_station_index = gets.chomp.to_i
    puts 'Выберите индекс станции из списка для конечной станции'
    end_station_index = gets.chomp.to_i

    start_st = @stations[start_station_index]
    end_st = @stations[end_station_index]
    route = Route.new(start_st, end_st)
    puts "Маршрут: #{route.start_station.name} -> #{route.end_station.name}"
    @routes << route
    route_list
  rescue ArgumentError => e
    puts e
    retry
  end

  def add_mid_station
    number_route = index_route
    station_list
    puts 'Выберите индекс станции из списка для промежуточной станции'
    mid_station_index = gets.chomp.to_i
    add_station(number_route, mid_station_index)
  end

  def delete_mid_station
    number_route = index_route
    puts 'Укажите имя удаляемой промежуточной станции'
    mid_station = gets.chomp.to_s
    delete_station(number_route, mid_station)
  end

  def assign_route
    number_route = index_route
    number_train = index_train
    @trains[number_train].assign_route(@routes[number_route])
    puts @routes[number_route].stations.to_s
  end

  def attach_carriage
    number_train = index_train
    add_carriage(number_train)
  end

  def unhook_carriage
    number_train = index_train
    puts 'Укажите номер удаляемого вагона'
    number_carriage = gets.chomp.to_i
    delete_carriage(number_train, number_carriage)
  end

  def move_train_next_station
    number_train = index_train
    train = @trains[number_train]
    puts "Текущая станция: #{train.current_station.name}"
    train.move_next_station
    puts "Текущая станция: #{train.current_station.name}"
  end

  def move_train_prev_station
    number_train = index_train
    train = @trains[number_train]
    puts "Текущая станция:  #{train.current_station.name}"
    train.move_prev_station
    puts "Текущая станция:  #{train.current_station.name}"
  end

  def all_stations
    number_route = index_route
    puts 'Списко станций:'
    @routes[number_route].stations.each { |st| print "#{st.name}; " }
  end

  def trains_by_station
    station_list
    puts 'Выберите индекс станции'
    number_station = gets.chomp.to_i
    @stations[number_station].each_train do |train|
      puts "Номер поезда: #{train.number_train}, тип поезда: #{train.type_train}, кол-во вагонов: #{train.carriages.size}"
    end
  end

  def carriages_by_train
    number_train = index_train
    number_carriage = 0
    @trains[number_train].each_carriage do |carriage|
      puts "№ вагона #{number_carriage += 1}, тип вагона: #{carriage.type}"
      puts "кол-во своб/зан мест: #{carriage.number_free_seats}/#{carriage.occupied_seats}" if carriage.passenger?
      puts "кол-во своб/занятого объема: #{carriage.number_free_vol}/#{carriage.occupied_volume}" if carriage.cargo?
    end
  end

  def occupy_space_or_volume
    number_train = index_train
    index = 0
    @trains[number_train].each_carriage do |carriage|
      puts "Номер вагона #{index += 1}, тип вагона: #{carriage.type}"
    end
    number_carriage = index_carriage
    carriage = @trains[number_train].carriages[number_carriage - 1]
    carriage.occupy_seats if carriage.passenger?
    occupy_volume(carriage) if carriage.cargo?
  end

  def index_train
    train_list
    puts 'Выберите индекс поезда из списка'
    gets.chomp.to_i
  end

  def index_route
    route_list
    puts 'Выберите индекс маршрута'
    gets.chomp.to_i
  end

  def station_list
    @stations.each_with_index do |st, index|
      puts "#{index}. #{st.name};"
    end
  end

  def route_list
    @routes.each_with_index do |rt, index|
      puts "#{index}. #{rt.start_station.name} -> #{rt.end_station.name};"
    end
  end

  def train_list
    @trains.each_with_index do |tr, id|
      puts "#{id}. № поезда: #{tr.number_train}, Тип поезда: #{tr.type_train}; "
    end
  end

  def index_carriage
    puts 'Укажите номер вагона'
    gets.chomp.to_i
  end

  def delete_station(number_route, mid_station)
    route = @routes[number_route]
    route.stations.each do |st|
      if st.name == mid_station
        route.delete_mid_station(st)
        route.stations.each { |station| print "#{station.name}; " }
      end
    end
  end

  def add_station(number_route, mid_station_index)
    route = @routes[number_route]
    station = @stations[mid_station_index]
    route.add_mid_station(station)
    route.stations.each { |st| print "#{st.name}; " }
  end

  def add_carriage(number_train)
    train = @trains[number_train]
    case train.type_train.to_s
    when 'cargo'
      volume = volume_carriage
      train.attach_carriage(CargoCarriage.new(volume))
    when 'passenger'
      number_seats = seats_carriage
      train.attach_carriage(PassengerCarriage.new(number_seats))
    end
    info_by_train(train)
  end

  def delete_carriage(number_train, number_carriage)
    train = @trains[number_train]
    train.carriages.each do |crg|
      next unless crg.number == number_carriage
      train.unhook_carriage(crg)
      info_by_train(train)
    end
  end

  def info_by_train(train)
    puts "Номер поезда: #{train.number_train}"
    puts "Тип поезда: #{train.type_train}"
    puts "Вагоны: #{train.carriages}"
  end

  def occupy_volume(carriage)
    puts 'Укажите занимаемый объем для вагона'
    volume = gets.chomp.to_i
    carriage.occupy_volume(volume)
  end

  def volume_carriage
    puts 'Укажите общий объем вагона'
    gets.chomp.to_i
  end

  def seats_carriage
    puts 'Укажите общее кол-во мест в вагоне'
    gets.chomp.to_i
  end
end
