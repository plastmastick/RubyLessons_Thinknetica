# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

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
    validate! @name, :presence
    validate! @name, :comparison, '< 2'
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
    validate! train, :include, trains
    trains << train
  end

  def send_train(train, forward)
    validate! train, :include, "!#{trains}"
    train.next_station if forward
    train.previous_station unless forward
    delete_train(train)
  end

  private

  attr_writer :trains

  def delete_train(train)
    validate! train, :comparison, "== #{self}"
    validate! train, :include, "!#{trains}"
    trains.delete(train)
  end
end
