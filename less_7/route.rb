require_relative 'module/validation'

class Route
  include Validation
  attr_reader :start_station, :end_station, :stations

  validate :start_station, :presence
  validate :end_station, :presence

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    validate!
    @stations = [start_station, end_station]
  end

  def add_mid_station(mid_stations)
    stations.insert(1, mid_stations)
  end

  def delete_mid_station(mid_stations)
    stations.delete(mid_stations)
  end
end

