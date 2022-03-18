class Route
  attr_reader :route

  def initialize(start_station, end_station)
    @route = [start_station, end_station]
  end

  def add_station(station)
    if !@route.include?(station)
      @route.insert(@route.length - 1, station)
    #else
      #puts "#{station.name} уже есть в маршруте!"
    end
  end

  def delete_station(station)
    if @route.include?(station) && ![@route.first, @route.last].include?(station)
      self.train_station_update(station)
      @route.delete(station)
    #else
      #puts "Станции '#{station.name}' нет в маршруте или она не является промежуточной!"
    end
  end

  private

  #Отправка поезда при удалении станции из маршрута
  #Внутренний метод, который не должен быть доступен извне для избежания багов
  def train_station_update(station)
    station.trains.each { |train| station.send_train(train, true) if train.train_route == self }
  end
end
