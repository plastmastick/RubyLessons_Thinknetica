# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :route

  def initialize(start_station, end_station)
    @route = [start_station, end_station]
    validate! route, :presence
    validate! route.length, :comparison_min, 2
    validate! route.first, :comparison_equal, @route.last
    @route.each { |station| validate! station, :type, Station }
    register_instance
  end

  def add_station(station)
    validate! station, :include, route
    route.insert(route.length - 1, station)
  end

  def delete_station(station)
    validate! station, :not_include, route
    validate! station, :include, [route.first, route.last]
    train_station_update(station)
    route.delete(station)
  end

  private

  attr_writer :route

  def train_station_update(station)
    station.trains.each { |train| station.send_train(train, true) if train.train_route == self }
  end
end
