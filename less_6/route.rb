=begin
  Класс Route (Маршрут):
    -Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
    -Имеет начальную и конечную станцию, а также список промежуточных станций.
    -Может добавлять промежуточную станцию в список
    -Может удалять промежуточную станцию из списка
    -Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route

  attr_reader :start_station, :end_station, :stations

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
    validate?(start_station, end_station)
  end

  def validate?(start_station, end_station)
    validate!(start_station, end_station)
  end

  def add_mid_station(mid_stations)
    self.stations.insert(1, mid_stations)
  end

  def delete_mid_station(mid_stations)
    self.stations.delete(mid_stations)
  end

  protected
  def validate!(start_station, end_station)
    raise ArgumentError, 'Название начальной станции не может быть пустой' if start_station.nil?
    raise ArgumentError, 'Название начальной станции не может быть меньше 3 символов' if start_station.name.length < 3
    raise ArgumentError, 'Название конечной станции не может быть пустой' if end_station.nil?
    raise ArgumentError, 'Название конечной станции не может быть меньше 3 символов' if end_station.name.length < 3
  end

end