class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  #Список всех поездов на станции
  def show_trains
    puts "Список поездов:"
    @trains.each { |train| puts "#{@trains.index(train) + 1}) №#{train.number};" }
  end

  #Список поездов на станции по типу
  def show_trains_type
    passenger_trains = 0
    cargo_trains = 0

    @trains.each do |train|
      if (1..2).include?(train.type)
        train.type == 1 ? passenger_trains += 1 : cargo_trains += 1
      else
        puts "Некорректное тип поезда №#{type.number}"
      end
    end

    puts "Пассажирских: #{passenger_trains}\nГрузовых: #{cargo_trains}"
  end

  #Прибытие поезда на станцию
  def add_train(train)
    if !@trains.include?(train)
      @trains << train
      puts "\nПоезд №#{train.number} прибыл на станцию '#{self.name}'"
    else
      puts "Поезд уже на станции!"
    end
  end

  #Удаление поезда со станции
  def delete_train(train)
    if @trains.include?(train)
      @trains.delete(train)
      puts "\nПоезд №#{train.number} покинул на станцию '#{self.name}'"
    else
      puts "Поезда №#{train.number} нет на станции!"
    end
  end

  #Отправка поезда со станции
  def send_train(train, forward = true)
    if forward && @trains.include?(train)
      train.next_station
    elsif !forward && @trains.include?(train)
      train.previous_station
    else
      puts "Поезда №#{train.number} нет на станции!"
    end
  end

  #Отправка поезда при удалении станции из маршрута
  def send_train_update(route)
    @trains.each { |train| send_train(train) if train.train_route == route }
  end
end


class Route
  attr_reader :route

  def initialize(start_station, end_station)
    @route = [start_station, end_station]
  end

  #Добавление промежуточной станции
  def add_station(station)
    if !@route.include?(station)
      @route.insert(@route.length - 1, station)
    else
      puts "#{station.name} уже есть в маршруте!"
    end
  end

  #Удаление промежуточной станции
  def delete_station(station)
    if @route.include?(station) && ![@route.first, @route.last].include?(station)
      station.send_train_update(self) #Отправка поезда при удалении станции из маршрута
      @route.delete(station)
    else
      puts "Станции '#{station.name}' нет в маршруте или она не является промежуточной!"
    end
  end

  def show_route
    puts "Список станций в маршруте:"
    @route.each { |station| puts "#{@route.index(station) + 1}) #{station.name};" }
  end
end


class Train
  attr_reader :type, :speed, :wagons_count, :number, :train_route

  def initialize(number, type, wagons_count)
    #type 1 - Пассажирский; type 2 - Грузовой
    @number = number
    @type = type.to_i
    @wagons_count = wagons_count.to_i
    @speed = 0
  end

  #Увеличение скорости
  def increase_speed
    @speed += 10
  end

  #Остановка поезда
  def stop
    @speed = 0
  end

  #Прицепка
  def add_wagon
    if @speed != 0
      puts "Прицеплен 1 вагон"
      @wagons_count += 1
    else
      puts "Поезд находится в движении!"
    end
  end

  #Отцепка
  def remove_wagon
    if @speed != 0
      puts "Отцеплен 1 вагон"
      @wagons_count -= 1
    else
      puts "Поезд находится в движении!"
    end
  end

  #Установить маршрут
  def set_route(route)
    @train_route = route
    @current_station = @train_route.route[0]
    @current_station.add_train(self)  #Добавить поезд на станцию
  end

  #Следующая станция
  def next_station
    station_index = @train_route.route.index(@current_station)

    if station_index != @train_route.route.length - 1
      @current_station.delete_train(self)
      @current_station = @train_route.route[station_index + 1]
      @current_station.add_train(self)  #Добавить поезд на станцию
    else
      puts "Поезд достиг конечной станции!"
    end
  end

  #Предыдущая станцию
  def previous_station
    station_index = @train_route.route.index(@current_station)

    if station_index != 0
      @current_station.delete_train(self)
      @current_station = @train_route.route[station_index - 1]
      @current_station.add_train(self)  #Добавить поезд на станцию
    else
      puts "Поезд находится на начальной станции!"
    end
  end

  #Информация о маршруте
  def route_info
    station_index = @train_route.route.index(@current_station)

    station_index != 0 ? previous_station = @train_route.route[station_index - 1].name : previous_station = "Отсутствует"
    station_index != @train_route.route.length - 1 ? second_station = @train_route.route[station_index + 1].name : second_station = "Отсутствует"

    puts "Предыдущая станция: #{previous_station};\nТекущая станция: #{@current_station.name};\nСледующая станция: #{second_station}"
  end
end
