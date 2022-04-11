# frozen_string_literal: true

class Railway
  attr_accessor :stations, :routes, :wagons, :trains

  def initialize
    @stations = []
    @routes = []
    @wagons = []
    @trains = []
  end

  def empty_wagons
    empty_wagons = []
    wagons.each { |wagon| empty_wagons << wagon if wagon.train.nil? }
    empty_wagons
  end

  def show_trains(type, station = nil)
    if type == 'all' && station.nil?
      @trains
    else
      station.show_trains_by_type(type)
    end
  end
end
