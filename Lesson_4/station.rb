class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    name_validate!
    register_instance
    @@stations << self
  end

  def trains_yield
    @trains.each { |train| yield train}
  end

  def show_trains_by_type(train_type)
    trains_by_type = []
    self.trains.each { |train| trains_by_type << train if train.type == train_type}
    trains_by_type
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

  def name_valid?
    name_validate!
    true
  rescue
    false
  end

  private

  attr_writer :trains

  #Нет подклассов. Поезд не должен удалять сам себя, т.к. отправкой занимается станция
  def delete_train(train)
    self.trains.delete(train) if @trains.include?(train) && train.current_station != self
  end

  def name_validate!
    raise "Name can't be nil!" if @name.nil?
    raise "Name should be at lest 2 symbols" if @name.length < 2
  end
end
