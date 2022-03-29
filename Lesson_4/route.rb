class Route
  include InstanceCounter

  attr_reader :route

  def initialize(start_station, end_station)
    @route = [start_station, end_station]
    route_validate!
    register_instance
  end

  def add_station(station)
    if !self.route.include?(station)
      self.route.insert(self.route.length - 1, station)
      true
    else
      false
    end
  end

  def delete_station(station)
    if self.route.include?(station) && ![self.route.first, self.route.last].include?(station)
      self.train_station_update(station)
      self.route.delete(station)
      true
    else
      false
    end
  end

  def route_valid?
    route_validate!
    true
  rescue
    false
  end

  private

  attr_writer :route
  #Отправка поезда при удалении станции из маршрута
  #Внутренний метод, который не должен быть доступен извне для избежания багов
  def train_station_update(station)
    station.trains.each { |train| station.send_train(train, true) if train.train_route == self }
  end

  def route_validate!
    raise "Route can't be nil!" if @route.nil?
    raise "Route should be have at least 2 station!" if @route.length < 2
    @route.each { |station| raise "Object is't a station:\n#{station}" if !station.is_a? Station }
  end

end
