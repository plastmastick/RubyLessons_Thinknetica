class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    register_instance
    @@stations << self
    @name = name
    @trains = []
  end

  def show_trains_by_type(train_type)
    trains_by_type = []
    self.trains.each { |train| trains_by_type << train if train.type == train_type}
    return trains_by_type
  end

  def add_train(train)
    if !@trains.include?(train) && train.current_station == self
      self.trains << train
      true
    else
      false
    end
  end

  def send_train(train, forward)
    if self.trains.include?(train) && train.current_station == self
      if forward
        return false if !train.next_station
      else
        return false if !train.previous_station
      end
      self.delete_train(train)
      true
    else
      false
    end
  end

  private

  attr_writer :trains

  #Нет подклассов. Поезд не должен удалять сам себя, т.к. отправкой занимается станция
  def delete_train(train)
    self.trains.delete(train) if @trains.include?(train) && train.current_station != self
  end
end
