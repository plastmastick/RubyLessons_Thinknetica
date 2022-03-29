class Interface
  attr_reader :railway

  def initialize
    @railway = Railway.new
  end

  def main_menu
    puts "\n\nУправление железной дорогой.\nГлавное меню."
    puts "\nВыберите номер опции:"
    puts "\n1) Управление станциями\n2) Управление поездами\n3) Управление маршрутами"
    puts "4) Создать пассажирский вагон\n5) Создать грузовой вагон\n0) Выход из программы"
    user_option = gets.chomp.to_i
    abort if user_option.zero?

    case user_option
    when 1
      station_menu
    when 2
      train_menu
    when 3
      route_menu
    when 4
      create_wagon("passenger")
      main_menu
    when 5
      create_wagon("cargo")
      main_menu
    else
      puts "Неизвестная команда!"
      main_menu
    end
  end

  def station_menu
    puts "\n\nМеню управление станциями."
    puts "\nВыберите номер опции:"
    puts "\n1) Создать станцию\n2) Список станций\n0) В главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 0
      main_menu
    when 1
      create_station
      station_menu
    when 2
      show_stations
      station_menu
    else
      puts "Неизвестная команда!"
      station_menu
    end
  end

  def station_submenu(station)
    puts "\n\nМеню управлением станцией #{station.name}"
    puts "Количестов поездов: #{station.trains.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Список всех поездов на станции\n2) Список грузовых поездов\n3) Список пассажирских поездов\n4) Меню управления станциями\n0) Главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 0
      main_menu
    when 1
      show_trains(station, "all")
      station_submenu(station)
    when 2
      show_trains(station, "cargo")
      station_submenu(station)
    when 3
      show_trains(station, "passenger")
      station_submenu(station)
    when 4
      station_menu
    end
  end

  def train_menu
    puts "\n\nМеню управлением поездами"
    puts "Количество поездов: #{self.railway.trains.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Создать пассажирский поезд\n2) Создать грузовой поезда\n3) Список поездов\n0) Выход в главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 0
      main_menu
    when 1
      create_train("passenger")
      train_menu
    when 2
      create_train("cargo")
      train_menu
    when 3
      show_trains("all")
      train_menu
    else
      puts "Неизвестная команда!"
      train_menu
    end
  end

  def train_submenu(train)
    puts "\n\nМеню управлением поездом #{train.number}"
    puts "Количество вагонов: #{train.wagons.length}"
    if train.train_route.nil?
      route_info = train.route_info
      route_info[0].nil? ? previous_station = "---" : previous_station = route_info[0].name
      route_info[1].nil? ? next_station = "---" : next_station = route_info[1].name
      puts "Следующая станция: #{next_station}\nТекущая станция: #{train.current_station.name}\nПредыдущая станция: #{previous_station}"
    else
      puts "Маршрут не назначен"
    end

    puts "\nВыберите номер опции:"
    puts "\n1) Назначить маршрут\n2) Добавить вагон\n3) Отцепить вагон\n4) Отправить поезд вперед\n5) Отправить поезд назад\n6) Выход в главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 1
      assign_train_route(train)
      train_submenu(train)
    when 2
      add_train_wagon(train)
      train_submenu(train)
    when 3
      delete_train_wagon(train)
      train_submenu(train)
    when 4
      send_train(train, true)
      train_submenu(train)
    when 5
      send_train(train, false)
      train_submenu(train)
    when 6
      main_menu
    else
      puts "Неизвестная команда!"
      train_submenu(train)
    end

  end

  def route_menu
    puts "\n\nМеню управлением маршрутам"
    puts "Количество маршрутов: #{self.railway.routes.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Создать маршрут\n2) Список маршрутов\n3) Выход в главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 1 #Создание маршрута
      create_route
      route_menu
    when 2 #Список маршрутов
      show_routes
    when 3 #Выход в главное меню
      main_menu
    else  #Ошибка
      puts "Неизвестная команда!"
      route_menu
    end
  end

  def route_submenu(route)
    puts "\n\nМеню маршрута #{route.route.first.name} -> #{route.route.last.name}"

    puts "\nВыберите опцию:\n1) Добавить промежуточную станцию\n2) Удалить промежуточную станцию\n3) Список станций в маршруте\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1  #Добавить промежуточную
      add_intermediate_station()
      return
    when 2  #Удалить промежуточную
      delete_intermediate_station()
      return
    when 3  #Список станций в маршруте
      puts "Список станций в маршруте:"
      route.route.each { |station| puts "#{route.route.index(station) + 1}) Станция #{station.name}"}
      return
    else  #Ошибка
      puts "Неизвестная команда"
    end
  end

  private

  def create_station
    puts "\nВведите название станции (СТОП для выхода):"
    user_option = gets.chomp

    if user_option.downcase != "стоп"
      new_station = Station.new(user_option)
      self.railway.stations << new_station
      puts "\nДобавлена новая станция #{new_station.name}"
    end
  end

  def show_stations
    if self.railway.stations.length > 0
      puts "Список станций:"
      self.railway.stations.each { |station| puts "#{self.railway.stations.index(station) + 1}) #{station.name} (Количество поездов: #{station.trains.length});" }
      puts "Для управления нужной станцией введите её порядковый номер (0 для выхода):"
      user_option = gets.chomp.to_i

      if (1..self.railway.stations.length).include?(user_option)
        station_submenu(self.railway.stations[user_option - 1])
      elsif user_option != 0
        puts "Неизвестная команда!"
      end
    else
      puts "Нет станций!"
    end
  end

  def show_trains(station = nil, type)
    trains = []
    if type == "all" && station.nil?
      trains = self.railway.trains
    elsif type == "all" && !station.nil?
      trains = station.trains
    elsif type == "cargo"
      trains = station.show_trains_by_type("cargo")
      puts "Количество грузовых поездов: #{trains.length}"
    elsif type == "passenger"
      trains = station.show_trains_by_type("passenger")
      puts "Количество пассажирских поездов: #{trains.length}"
    end

    if self.railway.trains.length > 0
      puts "Список поездов:"
      trains.each { |train| puts "#{trains.index(train) + 1}) #{train.number} (#{train.type});" }
      puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
      user_option = gets.chomp.to_i
      return if user_option.zero?

      if (1..trains.length).include?(user_option)
        train_submenu(trains[user_option - 1])
      else
        puts "Неизвестная команда!"
      end
    else
      puts "Отсутствуют"
    end
  end

  def create_train(type)
    puts "Введите номер поезда(0 для выхода):"
    number = gets.chomp
    return if number.to_i.zero?

    if type == "cargo"
      self.railway.trains << CargoTrain.new(number)
    elsif type == "passenger"
      self.railway.trains << PassengerTrain.new(number)
    else
      puts "Ошибка! Некорректный тип поезда"
      return
    end

    puts "Добавлен поезд #{railway.trains.last.number}"
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    create_train(type)
  end

  def send_train(train, forward)
    return puts "Маршрут не назначен" if train.train_route != nil

    if train.current_station.send_train(train, forward)
      puts "Поезд прибыл на станцию #{train.current_station.name}"
    else
      puts "Ошибка! Поезд не отправлен"
    end
  end

  def assign_train_route(train)
    return puts "Нет маршрутов!" if self.railway.routes.length > 0

    puts "Список маршрутов:"
    self.railway.routes.each { |route| puts "#{self.railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name}"}

    puts "\nВыберите порядковый номер маршрута для назначения (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..self.railway.routes.length).include?(user_option)
      train.set_route(self.railway.routes[user_option - 1])
      puts "Поезд #{train.number} движется по маршруту #{self.railway.routes[user_option - 1].route.first.name} -> #{self.railway.routes[user_option - 1].route.last.name}"
    else
      puts "Неизвестная команда!"
    end
  end

  def add_train_wagon(train)
    empty_wagons = self.railway.show_empty_wagons
    return puts "Нет подходящих вагонов!" if empty_wagons.length.zero?

    puts "Свободные вагоны:"
    empty_wagons.each { |wagon| puts "#{empty_wagons.index(wagon) + 1}) Вагон #{wagon.number}" }

    puts "\nВыберите вагон для прикрепления (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..empty_wagons.length).include?(user_option)
      if train.add_wagon(empty_wagons[user_option - 1])
        puts "Вагон #{empty_wagons[user_option - 1].number} прикреплен к поезду #{train.number}"
      else
        puts "Ошибка при прикреплении вагона!"
      end
    else
      puts "Неизвестная команда!"
    end
  end

  def delete_train_wagon(train)
    return puts "Нет вагонов!" if train.wagons.length.zero?

    puts "Список вагонов прикрепленных к поезду:"
    train.wagons.each { |wagon| puts "#{train.wagons.index(wagon) + 1}) Вагон №#{wagon.number}"}

    puts "\nВыберите вагон для отцепления (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..train.wagons.length).include?(user_option)
      if train.remove_wagon(train.wagons[user_option - 1])
        puts "Вагон открелен от поезда #{train.number}"
      else
        puts "Ошибка при открпелении вагона!"
      end
    else
      puts "Неизвестная команда!"
    end
  end

  def create_route
    return puts "Станций меньше 2!" if self.railway.stations.length < 2

    puts "Список станций:"
    self.railway.stations.each { |station| puts "#{self.railway.stations.index(station) + 1}) #{station.name} (Количество поездов: #{station.trains.length});" }

    puts "\nВведите порядковый номер начальной станции из списка (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    first_station = nil
    if (1..self.railway.stations.length).include?(user_option)
      first_station = self.railway.stations[user_option - 1]
    else
      puts "Неизвестная команда!"
      return
    end

    puts "\nВведите порядковый номер конечной станции из списка (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    last_station = nil
    if (1..self.railway.stations.length).include?(user_option)
      last_station = self.railway.stations[user_option - 1]
    else
      puts "Неизвестная команда!"
      return
    end

    return puts "Станции совпадают!" if first_station == last_station
    self.railway.routes << Route.new(first_station, last_station)
  end

  def show_routes
    return puts "Нет маршрутов!" if self.railway.routes.length.zero?

    puts "Список маршрутов:"
    self.railway.routes.each { |route| puts "#{self.railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name} (Количество промежуточных станций: #{route.route.length - 2})" }

    puts "Введите порядковый номер маршрута (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..self.railway.routes.length).include?(user_option)
      route_submenu(self.railway.routes[user_option - 1])
    else
      puts "Неизвестная команда!"
    end
  end

  def add_intermediate_station(route)
    return puts "Нет станций!" if self.railway.stations.length.zero?

    puts "Добавление промежуточной станции"
    puts "Список всех станций:"
    self.railway.stations.each { |station| puts "#{self.railway.stations.index(station) + 1}) #{station.name}" }

    puts "Введите номер добавляемой станции(0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..self.railway.stations.length).include?(user_option)
      if route.add_station(self.railway.stations[user_option - 1])
        puts "Станция #{self.railway.stations[user_option - 1].name} добавлена в маршрут"
      else
        puts "Ошибка при добавлении станции!"
      end
    else
      puts "Некорректный номер!"
    end
  end

  def delete_intermediate_station(route)
    puts "Удаление промежуточной станции"
    puts "Список станций маршрута:"
    route.route.each { |station| puts "#{route.route.index(station) + 1}) #{station.name}" }

    puts "Введите номер удаляемой станции(0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    if (1..route.route.length).include?(user_option)
      if route.delete_station(route.route[user_option - 1])
        puts "Станция удалена из маршрута"
      else
        puts "Ошибка при удалении станции!"
      end
    else
      puts "Некорректный номер!"
    end
  end

  def create_wagon(type)
    if type == "passenger"
      self.railway.wagons << PassengerWagon.new("PW-#{self.railway.wagons.length + 1}")
    elsif type == "cargo"
      self.railway.wagons << CargoWagon.new("CW-#{self.railway.wagons.length + 1}")
    end
    puts "Создан вагон #{self.railway.wagons.last.number} (Тип: #{self.railway.wagons.last.type})"
  end
end
