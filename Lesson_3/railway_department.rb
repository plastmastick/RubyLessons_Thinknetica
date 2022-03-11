class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  #Прибытие поезда на станцию
  def add_train(train)
    @trains << train #проверка на существовании поезда
    #устаовить текущую станцию поезда

  end

  #Список всех поездов на станции
  def show_trains
    puts "Список поездов:"
    @trains.each { |train| puts "#{train.number}" }   #Скорректировать
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

  #Отправка поезда со станции
  def send_train(train)
    #Смена станции поезда
    train.next_station

    #установить текущую станцию поезда

    #Удаление поезда со станции
    @trains.delete(train)
  end
end


class Route
  attr_reader :route

  def initialize(start_station, end_station)  #Добавить промежуточную станцию
    @route = []
    @route << start_station
    @route << end_station
  end

  def add_station(station)
    @route.insert(@route.lenght - 1, station) #проверка на существовании станции
  end

  def delete_station(station)
    puts "Станции #{station} нет в маршруте!" if !@route.include?(station)
    @route.delete(station)

    #перемещение всех поездов на предыдущую станцию

  end

  def show_route
    puts "Список станций в маршруте:"
    @route.each { |station| puts "#{@route.index(station) + 1}) #{station.name};" }
  end
end


class Train
  attr_reader :type, :speed, :wagons_count, :number

  def initialize(number, type, wagons_count)
    #type 1 - Пассажирский; type 2 - Грузовой
    @number = number
    @type = type.to_i
    @wagons_count = wagons_count.to_i
  end

  #Увеличение скорости
  def increase_speed
    @speed += 10
  end

  #Остановка поезда
  def stop
    @speed = 0
  end

  #Прицепка/отцепка
  def change_wagons(remove = false)
    #Добавить проверку на пребывание поезда на станции

    #Прицепка/отцепка
    puts remove ? "Отцеплен 1 вагон" : "Прицеплен 1 вагон"
    if remove
      @wagons_count -= 1
    else
      @wagons_count += 1
    end
  end

  #Установить маршрут
  def set_route(route)
    @train_route = route
    @current_station = @train_route.route[0]
    #добавить поезд на станцию
    @current_station.add_train(self) #проверка на существовании поезда
  end

  #Следующая станция
  def next_station
    station_index = @train_route.index(@current_station)
    @current_station = @train_route.route[station_index + 1] #ограничение диапазона
  end

  #Предыдущая станцию
  def previous_station
    station_index = @train_route.index(@current_station)
    @current_station = @train_route.route[station_index - 1] #ограничение диапазона
  end

  #Информация о маршруте
  def route_info
    #Ограничение станций
    current_station = @train_route[@train_route.index(@current_station)]
    previous_station = @train_route[current_station - 1]
    second_station = @train_route[current_station + 1]
    puts "Предыдущая станция: #{previous_station};\nТекущая станция: #{current_station};\nСледующая станция: #{second_station}"
  end
end
