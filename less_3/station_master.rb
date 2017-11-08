load 'station.rb'
load 'train.rb'
load 'route.rb'

class StationMaster

  def initialize(name_station, number_train, type_train, count_rw_carriage, start_station, end_station)
    @station = Station.new(name_station)
    @train = Train.new(number_train, type_train, count_rw_carriage)
    @route = Route.new(Station.new(start_station), Station.new(end_station))

    @route.add_mid_station(Station.new('Osipovichi'))
    @route.add_mid_station(Station.new('Brest'))
    @route.add_mid_station(Station.new('Grodno'))

    demo
  end

  def demo
    puts 'station methods'

    puts 'add_train:'
    puts @station.add_train(@train)

    puts 'get_list_type_train:'
    puts @station.get_list_type_train(@train.type_train)

    puts 'send_train:'
    puts @station.send_train(@train.number_train)

    puts '----------------------------------------'

    puts 'route methods'

    puts 'add mid station:'
    puts @route.add_mid_station('Kalinkovichi')

    puts 'delete mid station:'
    puts @route.delete_mid_station('Kalinkovichi')
    puts 'list_stations: '
    puts @route.stations

    puts '----------------------------------------'

    puts 'train methods'
    puts 'go (20/40/-50/get current speed/stop): '
    puts @train.go(20)
    puts @train.go(40)
    puts @train.go(-50)
    puts @train.speed
    puts @train.stop

    puts 'attach carriage: '
    puts @train.attach_carriage
    puts @train.attach_carriage
    puts 'unhook carriage: '
    puts @train.unhook_carriage

    puts 'assign route:'
    puts @train.assign_route(@route)
    puts 'current station:'
    puts @train.current_station
    puts 'next/prev station:'
    puts @train.get_next_station
    puts @train.get_prev_station

    puts 'move next/prev/next station:'
    puts @train.move_next_station
    puts @train.move_prev_station
    puts @train.move_next_station

  end

end