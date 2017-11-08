require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'


=begin
  Добавить текстовый интерфейс:

  Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
  !- Создавать станции
  !- Создавать поезда
  !- Создавать маршруты и управлять станциями в нем (добавлять, удалять)
  !- Назначать маршрут поезду
  !- Добавлять вагоны к поезду
  !- Отцеплять вагоны от поезда
  !- Перемещать поезд по маршруту вперед и назад
  !- Просматривать список станций и список поездов на станции

  Маршрутов, станций, поездов может быть много.
  Нужно уметь показывать их списки и выбирать из уже созданных объектов.
=end

class Main
  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def menu
    loop do
      # system "clear"
      puts ''
      puts 'Выберите один из пунктов меню - указав индекс меню:'
      puts '1. Создать станцию'
      puts '2. Создать поезд'
      puts '3. Создать маршрут'
      puts '3.1. Добавить промежуточную станцию к маршруту'
      puts '3.2. Удалить промежуточную станцию из маршруту'
      puts '4. Назначить маршрут для поезда'
      puts '5. Добавить вагон к поезду'
      puts '6. Отцепить вагон от поезда'
      puts '7. Переместить поезд вперед'
      puts '8. Переместить поезд назад'
      puts '9. Просмотреть список станций'
      puts '10. Просмотреть список поездов на станции'
      puts '0. Выход'
      puts '=--------------------------------------------------='
      puts ''

      menu_index = gets.chomp.to_f
      puts menu_index

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
          stations
        when 10
          trains_by_station
        when 0
          break
        else
          puts 'Я не знаю такого значения'
      end
    end
  end

  private
  attr_accessor :stations, :trains, :routes

  def create_station
    puts 'Укажите имя станции:'
    name = gets.chomp.to_s
    if name != ''
      @stations << Station.new(name)
      puts @stations.to_s
    else
      puts 'Имя станции не может быть пустым' if name == ''
    end
  end

  def create_train
    puts 'Укажите тип поезда (cargo/passenger)'
    tp_train = gets.chomp.to_s
    puts 'Укажите номер поезда'
    number_train = gets.chomp.to_i

    if tp_train == 'passenger'
      @trains << PassengerTrain.new(number_train)
      puts @trains.to_s
    elsif tp_train == 'cargo'
      @trains << CargoTrain.new(number_train)
      puts @trains.to_s
    else
      puts 'Вы указали не правильный тип поезда'
    end
  end

  def create_route
    get_station_list
    puts 'Выберите индекс станции из списка для начальной станции'
    start_station_index = gets.chomp.to_i
    puts 'Выберите индекс станции из списка для конечной станции'
    end_station_index = gets.chomp.to_i

    if start_station_index != '' && end_station_index != ''
      start_st = @stations[start_station_index-1]
      end_st = @stations[end_station_index-1]
      route = Route.new(start_st, end_st)
      puts 'Маршрут: ' + route.start_station.name + ' -> ' + route.end_station.name

      # добавим новый маршрут ко всем маршрутам
      @routes << route
      get_route_list
    else
      puts 'Станции не могут быть пустыми' if start_station == '' || end_station == ''
    end
  end

  def add_mid_station
    get_route_list
    puts 'Выберите индекс маршрута'
    number_route = gets.chomp.to_i

    get_station_list
    puts 'Выберите индекс станции из списка для промежуточной станции'
    mid_station_index = gets.chomp.to_i

    add_station(number_route, mid_station_index)
  end

  def delete_mid_station
    get_route_list
    puts 'Выберите индекс маршрута'
    number_route = gets.chomp.to_i
    puts 'Укажите имя удаляемой промежуточной станции'
    mid_station = gets.chomp.to_s
    delete_station(number_route, mid_station)
  end

  def assign_route
    get_route_list
    puts 'Выберите индекс маршрута'
    number_route = gets.chomp.to_i

    get_train_list
    puts 'Укажите индекс поезда'
    number_train = gets.chomp.to_i

    if @routes[number_route-1] && @trains[number_train-1]
      @trains[number_train-1].assign_route(@routes[number_route-1])
      puts @routes[number_route-1].stations.to_s
    else
      puts 'Создайте поезд и маршрут'
    end
  end

  def attach_carriage
    get_train_list
    puts 'Укажите индекс поезда'
    number_train = gets.chomp.to_i
    puts 'Укажите номер вагона'
    number_carriage = gets.chomp.to_i
    add_carriage(number_train, number_carriage)
  end

  def unhook_carriage
    get_train_list
    puts 'Укажите индекс поезда'
    number_train = gets.chomp.to_i
    puts 'Укажите номер удаляемого вагона'
    number_carriage = gets.chomp.to_i
    delete_carriage(number_train, number_carriage)
  end

  def move_train_next_station
    get_train_list
    puts 'Укажите индекс поезда'
    number_train = gets.chomp.to_i
    if @trains && @trains[number_train-1]
      train = @trains[number_train-1]
      puts 'Текущая станция: ' + train.current_station.name
      train.move_next_station
      puts 'Текущая станция: ' + train.current_station.name
    else
      puts 'Данный поезд не найден'
    end
  end

  def move_train_prev_station
    get_train_list
    puts 'Укажите индекс поезда'
    number_train = gets.chomp.to_i
    if @trains && @trains[number_train-1]
      train = @trains[number_train-1]
      puts "Текущая станция:  #{train.current_station.name}"
      train.move_prev_station
      puts "Текущая станция:  #{train.current_station.name}"
    else
      puts 'Создайте поезд'
    end
  end

  def stations
    get_route_list
    puts 'Выберите индекс маршрута'
    number_route = gets.chomp.to_i

    if @routes && @routes[number_route - 1]
      puts 'Списко станций:'
      @routes[number_route - 1].stations.each {|st| print st.name + ' '}
    else
      'Создайте маршрут'
    end
  end

  def trains_by_station
    puts 'Укажите станцию'
    station = gets.chomp.to_s

    if @stations
      @stations.each do |st|
        if st.name == station
          count = st.get_list_train
          puts "На данной станции: #{count} поезд"
        end
      end
    else
      puts 'Данная станция или маршрут не найдены'
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  def get_station_list
    @stations.each_with_index do |st, index|
      puts "#{index+1}. #{st.name};"
    end
  end

  def get_route_list
    @routes.each_with_index do |rt, index|
      puts "#{index+1}. #{rt.start_station.name} -> #{rt.end_station.name};"
    end
  end

  def get_train_list
    @trains.each_with_index do |tr, index|
      puts "#{(index+1)}. Номер поезда: #{tr.number_train}, Тип поезда: #{tr.type_train}; "
    end
  end

  def delete_station(number_route, mid_station)
    route = @routes[number_route-1]
    if @routes && mid_station && route
      route.stations.each do |st|
        if st.name == mid_station
          route.delete_mid_station(st)
          route.stations.each { |st| print st.name + ' ' }
        end
      end
    elsif !route
      puts 'Такой маршрут не найден'
    elsif !@routes
      puts 'Еще не создан ни один маршрут'
    elsif mid_station == ''
      puts 'Станция не может быть пустой'
    end
  end

  def add_station(number_route, mid_station_index)
    route = @routes[number_route-1]
    if @routes && @stations[mid_station_index - 1] && route
      station = @stations[mid_station_index - 1]
      route.add_mid_station(station)
      route.stations.each { |st| print st.name + ' ' }
    elsif !route
      puts 'Такой маршрут не найден'
    elsif !@routes
      puts 'Еще не создан ни один маршрут'
    elsif !@stations[mid_station_index - 1]
      puts 'Данная станция не найдена'
    elsif mid_station_index == ''
      puts 'Станция не может быть пустой'
    end
  end

  def add_carriage(number_train, number_carriage)
    train = @trains[number_train-1]
    if train
      case train.type_train.to_s
        when 'cargo'
          train.attach_carriage(CargoCarriage.new(number_carriage))
          puts "Номер поезда: #{train.number_train}, Тип поезда: #{train.type_train}, Вагоны: #{train.carriages}"
        when 'passenger'
          train.attach_carriage(PassengerCarriage.new(number_carriage))
          puts "Номер поезда: #{train.number_train}, Тип поезда: #{train.type_train}, Вагоны: #{train.carriages}"
        else
          puts 'Создайте поезд'
      end
    end
  end

  def delete_carriage(number_train, number_carriage)
    train = @trains[number_train-1]
    if train
      train.carriages.each do |crg|
        if crg.number_carriage == number_carriage
          train.unhook_carriage(crg)
          puts "Номер поезда: #{train.number_train}, Тип поезда: #{train.type_train}, Вагоны: #{train.carriages}"
        end
      end
    else
      puts 'Создайте поезд'
    end
  end

end