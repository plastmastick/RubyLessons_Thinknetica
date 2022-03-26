class Route
  include InstanceCounter

  attr_reader :route

  def initialize(start_station, end_station)
    register_instance
    @route = [start_station, end_station]
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

  private

  attr_writer :route
  #Отправка поезда при удалении станции из маршрута
  #Внутренний метод, который не должен быть доступен извне для избежания багов
  def train_station_update(station)
    station.trains.each { |train| station.send_train(train, true) if train.train_route == self }
  end
end
