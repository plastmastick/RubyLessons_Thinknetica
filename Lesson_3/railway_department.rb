class Station

  def initialize(name)
    @name = name
    @trains = []
  end

  #Прибытие поезда на станцию
  def add_train(train)
    @trains << train
  end

  #Список всех поездов на станции
  def show_trains
    puts "Список поездов:"
    @trains.each { |train| puts "#{train}" }   #Скорректировать
  end

  #Список поездов на станции по типу
  def show_trains_type
    #код
    passenger_trains = 0
    cargo_trains = 0

    trains.each do |train|
      puts train.type == 1? passenger_trains += 1 : cargo_trains += 1
    end
    puts "Пассажирских: #{passenger_trains}\nГрузовых: #{cargo_trains}"
  end

  #Отправка поезда со станции
  def send_train(train)
    #Смена станции поезда

    #Удаление поезда со станции
    @trains.delete(train)
  end

end


class Route

  def initialize(start_station, end_station)  #Добавить промежуточную станцию
    @start_station = start_station
    @end_station = end_station
  end

end


class Train
  attr_reader :type, :speed, :wagons_count

  def initialize(number, type, wagons_count)
    #type 1 - Пассажирский; type 2 - Грузовой
    @number = number.to_i
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
  def change_wagons(count, remove = false)
    #Добавить проверку на пребывание поезда на станции

    #Прицепка/отцепка
    if remove
      wagons_count += 1
    else
      wagons_count -= 1
    end
  end

  def set_route

  end
end
