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
  attr_reader :station, :train, :route

  def initialize
    @station, @route, @train = ''
    @stations, @routes, @trains = []
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
  attr_writer :stations, :trains, :routes

  def create_station
    puts 'Укажите имя станции:'
    name = gets.chomp.to_s
    if name != ''
      @stations << Station.new(name)
      puts @stations
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
      @train = PassengerTrain.new(number_train)
      puts @train.number_train
    elsif tp_train == 'cargo'
      @train = CargoTrain.new(number_train)
      puts @train.number_train
    else
      puts 'Вы указали не правильный тип поезда'
    end
  end

  def create_route
    puts 'Укажите начальную станцию'
    start_station = gets.chomp.to_s
    puts 'Укажите конечную станцию'
    end_station = gets.chomp.to_s

    if start_station != '' && end_station != ''
      @route = Route.new(Station.new(start_station), Station.new(end_station))
      puts 'Маршрут: ' + @route.start_station.name_station + ' -> ' + @route.end_station.name_station
    else
      puts 'Станции не могут быть пустыми' if start_station == '' || end_station == ''
    end
  end

  def add_mid_station
    puts 'Укажите имя промежуточной станции'
    mid_station = gets.chomp.to_s

    if @route && mid_station != ''
      @route.add_mid_station(Station.new(mid_station))
      puts @route.stations.to_s
    elsif !@route
      puts 'Еще не создан ни один маршрут'
    elsif mid_station == ''
      puts 'Станция не может быть пустой'
    end
  end

  def delete_mid_station
    puts 'Укажите имя удаляемой промежуточной станции'
    mid_station = gets.chomp.to_s

    if @route && mid_station != ''
      @route.delete_mid_station(mid_station)
      puts @route.stations.to_s
    elsif !@route
      puts 'Еще не создан ни один маршрут'
    elsif mid_station == ''
      puts 'Станция не может быть пустой'
    end
  end

  def assign_route
    if @train && @route
      @train.assign_route(@route)
      puts @train.route.stations.to_s
    else
      puts 'Создайте поезд и маршрут'
    end
  end

  def attach_carriage
    puts 'Укажите номер вагона'
    number_carriage = gets.chomp.to_i
    puts @train.type_train
    if @train && @train.type_train.to_s == 'cargo'
      @train.attach_carriage(CargoCarriage.new(number_carriage))
      puts @train
    elsif @train && @train.type_train.to_s == 'passenger'
      @train.attach_carriage(PassengerCarriage.new(number_carriage))
      puts @train
    else
      puts 'Создайте поезд'
    end
  end

  def unhook_carriage
    puts 'Укажите номер удаляемого вагона'
    number_carriage = gets.chomp.to_i
    if @train
      @train.unhook_carriage(number_carriage)
      puts @train
    else
      puts 'Создайте поезд'
    end
  end

  def move_train_next_station
    if @train
      puts 'Текущая станция: ' + @train.current_station.name_station
      @train.move_next_station
      puts 'Текущая станция: ' + @train.current_station.name_station
    else
      puts 'Создайте поезд'
    end
  end

  def move_train_prev_station
    if @train
      puts 'Текущая станция: ' + @train.current_station.name_station
      @train.move_prev_station
      puts 'Текущая станция: ' + @train.current_station.name_station
    else
      puts 'Создайте поезд'
    end
  end

  def stations
    if @route
      puts 'Списко станций:'
      puts @route.stations.to_s
    else
      'Создайте маршрут'
    end
  end

  def trains_by_station
    puts 'Укажите станцию'
    station = gets.chomp.to_s
    if @route
      @route.stations.each do |st|
        if st.name_station == station
          count = st.get_list_train
          puts 'На данной станции: ' + count.to_s + ' поезд'
        end
      end
    else
      puts 'Данная станция или маршрут не найдены'
    end
  end

end

# Main.menu


