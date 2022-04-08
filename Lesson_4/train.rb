# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter
  include Accessors
  include Validation

  attr_reader :type, :number, :current_station, :wagons

  attr_accessor_with_history :speed
  strong_attr_accessor :train_route

  NAME_FORMAT = /^\w{3}(-\w{2})?$/i.freeze

  validate :number, :presence
  validate :number, :format, NAME_FORMAT

  @trains = []

  def self.find(number)
    @trains.find { |train| train.number == number }
  end

  def self.add_train(train)
    @trains ||= []
    @trains << train
  end

  def initialize(number)
    @number = number
    @type = train_type
    @wagons = []
    self.speed = 0
    @current_station = nil

    validate!
    register_instance
    self.class.add_train(self)
  end

  def wagons_yield(&block)
    @wagons.each(&block)
  end

  def increase_speed
    self.speed += 10
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    manipulate_wagon_validate!(wagon, 'add')
    wagons << wagon
    wagon.train = (self)
  end

  def remove_wagon(wagon)
    manipulate_wagon_validate!(wagon, 'remove')
    wagons.delete(wagon)
    wagon.train = (nil)
  end

  def select_route(route)
    train_route_set(route, Route)
    @current_station = train_route.route.first
    @current_station.add_train(self)
  end

  def next_station
    move_train_validate!('next')
    nearby_stations = route_info
    @current_station = nearby_stations[1]
    @current_station.add_train(self)
  end

  def previous_station
    move_train_validate!('back')
    nearby_stations = route_info
    @current_station = nearby_stations[0]
    @current_station.add_train(self)
  end

  def route_info
    route = train_route.route
    previous_station = @current_station == route.first ? nil : route[route.index(@current_station) - 1]
    next_station = @current_station == route.last ? nil : route[route.index(@current_station) + 1]
    [previous_station, next_station]
  end

  protected

  attr_writer :wagons

  def train_type
    'undefined'
  end

  def correct_wagon?(wagon)
    wagon.type == type && wagon.type != 'undefined'
  end

  def move_train_validate!(option)
    validate! current_station, :presence

    case option
    when 'next'
      raise 'The train is at the start station' if @train_route.route.last == @current_station
    when 'back'
      raise 'The train is at the end station' if @train_route.route.first == @current_station
    end
  end

  def manipulate_wagon_validate!(wagon, option)
    raise 'Train speed should be a zero!' unless self.speed.zero?

    case option
    when 'add'
      raise 'Incorrect type of wagon!' unless correct_wagon?(wagon)
      raise "Train alredy include this wagon #{wagon}" if wagons.include?(wagon)
    when 'remove'
      raise "Train not include this wagon #{wagon}" unless wagons.include?(wagon)
    end
  end
end
