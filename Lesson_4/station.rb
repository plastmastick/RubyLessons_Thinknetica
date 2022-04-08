# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :type, String
  validate :name, :comparison_min_length, 2

  @stations = []

  def self.all
    @stations
  end

  def self.add_station(station)
    @stations << station
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    self.class.add_station(self)
  end

  def trains_yield(&block)
    @trains.each(&block)
  end

  def show_trains_by_type(train_type)
    trains_by_type = []
    if train_type == 'any'
      trains_by_type = @trains
    else
      trains.each { |train| trains_by_type << train if train.type == train_type }
    end
    trains_by_type
  end

  def add_train(train)
    add_train_validate!(train)
    trains << train
  end

  def send_train(train, forward)
    send_train_validate!(train)
    train.next_station if forward
    train.previous_station unless forward
    delete_train(train)
  end

  private

  attr_writer :trains

  def delete_train(train)
    delete_train_validate!(train)
    trains.delete(train)
  end

  def send_train_validate!(train)
    raise 'Train not at the station!' unless trains.include?(train)
  end

  def add_train_validate!(train)
    raise 'Train alredy on the station!' if trains.include?(train)
  end

  def delete_train_validate!(train)
    raise 'Train current station is equal selected station' if train.current_station == self
    raise 'Train not at the station!' unless trains.include?(train)
  end
end
