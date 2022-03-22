class Interface
  attr_reader :railway

  def initialize
    @railway = Railway.new
  end

  def main_menu
    puts "__________\nУправление железной дорогой.\nГлавное меню."
    puts "\nВыберите номер опции:"
    puts "\n1) Управление станциями\n2) Управление поездами\n3) Управление маршрутами\n0) Выход из программы"
    user_option = gets.chomp.to_i

    case user_option
    when 1
      station_menu
    when 2
      train_menu
    when 3
      route_menu
    when 0
      abort
    else
      puts "Неизвестная команда!"
      main_menu
    end
  end

  def station_menu
    puts "__________\nУправление железной дорогой.\nМеню управление станциями."
    puts "\nВыберите номер опции:"
    puts "\n1) Создать станцию\n2) Список станций\n3) В главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 1
      create_station
      station_menu
    when 2
      show_stations
      station_menu
    when 3
      main_menu
    else
      puts "Неизвестная команда!"
      station_menu
    end
  end

  def station_submenu(station)
    puts "__________\nМеню управлением станцией #{station.name}"
    puts "Количестов поездов: #{station.trains.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Список всех поездов на станции\n2) Список грузовых поездов\n3) Список пассажирских поездов\n4) Меню управления станциями\n5) Главное меню"
    user_option = gets.chomp.to_i

    case user_option
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
    when 5
      main_menu
    end
  end

  def train_menu
    puts "__________\nМеню управлением поездами"
    puts "Количество поездов: #{self.railway.trains.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Создать пассажирский поезд\n2) Создать грузовой поезда\n3) Список поездов\n4) Выход в главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 1
      create_train("passenger")
      train_menu
    when 2
      create_train("cargo")
      train_menu
    when 3  #Список поездов
      show_trains("all")
      train_menu
    when 4  #Главное меню
      main_menu
    else  #Ошибка
      puts "Неизвестная команда!"
      train_menu
    end
  end

  def train_submenu(train)
    puts "__________\nМеню управлением поездом #{train.number}"
    puts "Количество вагонов: #{train.wagons.length}"
    if train.train_route != nil
      route_info = train.route_info
      route_info[0] == nil ? previous_station = "---" : previous_station = route_info[0].name
      route_info[1] == nil ? next_station = "---" : next_station = route_info[1].name
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
    puts "__________\nМеню управлением маршрутам"
    puts "Количество маршрутов: #{self.railway.routes.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Создать маршрут\n2) Список маршрутов\n3) Выход в главное меню"
    user_option = gets.chomp.to_i

    case user_option
    when 1 #Создание маршрута
      create_route
    when 2 #Список маршрутов
      show_routes
    when 3 #Выход в главное меню
      main_menu
    else  #Ошибка
      puts "Неизвестная команда!"
      route_menu
    end
  end

  private

  def create_station
    puts "\nВведите название станции (СТОП для выхода):"
    user_input = gets.chomp

    if user_input.downcase != "стоп"
      new_station = Station.new(user_input)
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
    if type == "all" && station == nil
      trains = self.railway.trains
    elsif type == "all" && station != nil
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

      if (1..trains.length).include?(user_option)
        train_submenu(trains[user_option - 1])
      elsif user_option != 0
        puts "Неизвестная команда!"
      end
    else
      puts "Отсутствуют"
    end
  end

  def create_train(type)
    if type == "cargo"
      self.railway.trains << CargoTrain.new("C-" + "#{self.railway.trains.length + 1}")
    elsif type == "passenger"
      self.railway.trains << PassengerTrain.new("P-#{self.railway.trains.length + 1}")
    else
      puts "Ошибка! Некорректный тип поезда"
    end

    puts "Добавлен поезд #{railway.trains.last.number}"
  end

  def send_train(train, forward)
    if train.train_route != nil
      if train.current_station.send_train(train, forward)
        puts "Поезд прибыл на станцию #{train.current_station.name}"
      else
        puts "Ошибка! Поезд не отправлен"
      end
    else
      puts "Маршрут не назначен"
    end
  end

  def assign_train_route(train)
    if self.railway.routes.length > 0
      puts "Список маршрутов:"
      self.railway.routes.each { |route| puts "#{self.railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name}"}

      puts "\nВыберите порядковый номер маршрута для назначения (0 для выхода):"
      user_option = gets.chomp.to_i

      if (1..self.railway.routes.length).include?(user_option)
        train.set_route(self.railway.routes[user_option - 1])
        puts "Поезд #{train.number} движется по маршруту #{self.railway.routes[user_option - 1].route.first.name} -> #{self.railway.routes[user_option - 1].route.last.name}"
      elsif user_option != 0
        puts "Неизвестная команда!"
      end
    else
      puts "Нет маршрутов!"
    end
  end

  def add_train_wagon(train)
    empty_wagons = self.railway.show_empty_wagons

    if empty_wagons.length > 0
      puts "Свободные вагоны:"
      empty_wagons.each { |wagon| puts "#{empty_wagons.index(wagon) + 1}) Вагон #{wagon.number}" }
      puts "\nВыберите вагон для прикрепления (0 для выхода):"
      user_option = gets.chomp.to_i

      if (1..empty_wagons.length).include?(user_option)
        if train.add_wagon(empty_wagons[user_option - 1])
          puts "Вагон #{empty_wagons[user_option - 1].number} прикреплен к поезду #{train.number}"
        else
          puts "Ошибка при прикреплении вагон!"
        end
      elsif user_option != 0
        puts "Неизвестная команда!"
      end
    else
      puts "Подходящие вагоны отсутствуют. Создать?\n1 - Да\n2 - Нет"
      user_option = gets.chomp.to_i

      case user_option
      when 1
        if train.type == "passenger"
          self.railway.wagons << PassengerWagon.new("PW-#{self.railway.wagons.length + 1}")
        elsif train.type == "cargo"
          self.railway.wagons << CargoWagon.new("CW-#{self.railway.wagons.length + 1}")
        end
        puts "Создан вагон #{self.railway.wagons.last.number} (Тип: #{self.railway.wagons.last.type})"
      when 2
        puts "Нет вагонов!"
      else
        puts "Неизвестная команда!"
      end
    end
  end

  def delete_train_wagon(train)
    if train.wagons.length > 0
      puts "Список вагонов прикрепленных к поезду:"
      train.wagons.each { |wagon| puts "#{train.wagons.index(wagon) + 1}) Вагон №#{wagon.number}"}
      puts "\nВыберите вагон для отцепления (0 для выхода):"
      user_option = gets.chomp.to_i

      if (1..train.wagons.length).include?(user_option)
        if train.remove_wagon(train.wagons[user_option - 1])
          puts "Вагон открелен от поезда #{train.number}"
        else
          puts "Ошибка при открпелении вагона!"
        end
      elsif user_option != 0
        puts "Неизвестная команда!"
      end
    else
      puts "Нет вагонов!"
    end
  end

  def create_route
    first_station = nil
    last_station = nil
    if self.railway.stations.length != 0
      puts "Список станций:"
      self.railway.stations.each { |station| puts "#{self.railway.stations.index(station) + 1}) #{station.name} (Количество поездов: #{station.trains.length});" }

      #выбор станции
      puts "\nВведите порядковый номер начальной станции из списка (0 для выхода):"
      user_input = gets.chomp.to_i

      if user_input == 0
        route_menu
      elsif (1..self.railway.stations.length).include?(user_input)
        first_station = self.railway.stations[user_input - 1]
      else
        puts "Неизвестная команда!"
        route_menu
      end

      puts "\nВведите порядковый номер конечной станции из списка (0 для выхода):"
      user_input = gets.chomp.to_i

      if user_input == 0
        route_menu
      elsif (1..self.railway.stations.length).include?(user_input)
        last_station = self.railway.stations[user_input - 1]
      else
        puts "Неизвестная команда!"
        route_menu
      end

      if first_station != last_station
        self.railway.routes << Route.new(first_station, last_station)
      else
        puts "Станция не может быть начальной и конечной одновременно!"
      end
      route_menu
    else
      puts "Станции отсутствуют!"
      route_menu
    end
  end

  def show_routes
    if self.railway.routes.length != 0
      puts "Список маршрутов:"
      self.railway.routes.each { |route| puts "#{self.railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name} (Количество промежуточных станций: #{route.route.length - 2})" }

      puts "Введите порядковый номер маршрута (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        route_menu
      elsif (1..self.railway.routes.length).include?(user_option)
        user_route = self.railway.routes[user_option - 1]
        puts "Маршрут #{user_route.route.first.name} -> #{user_route.route.last.name}"
        puts "\nВыберите опцию:\n1) Добавить промежуточную станцию\n2) Удалить промежуточную станцию\n3) Список станций в маршруте\n4) Выход в меню управления маршрутами"
        user_input = gets.chomp.to_i

        case user_input
        when 1  #Добавить промежуточную
          add_intermediate_station(user_route)
          route_menu
        when 2  #Удалить промежуточную
          delete_intermediate_station(user_route)
          route_menu
        when 3  #Список станций в маршруте
          puts "Список станций в маршруте:"
          user_route.route.each { |station| puts "#{user_route.route.index(station) + 1}) Станция #{station.name}"}
          route_menu
        when 4
          route_menu
        else  #Ошибка
          puts "Неизвестная команда"
          route_menu
        end

      else  #Ошибка
        puts "Неизвестная команда!"
        route_menu
      end

    else
      puts "Нет маршрутов!"
      route_menu
    end
  end

  def add_intermediate_station(route)
    puts "Добавление промежуточной станции"

    if self.railway.stations.length > 0
      puts "Список всех станций:"
      self.railway.stations.each { |station| puts "#{self.railway.stations.index(station) + 1}) #{station.name}" }
      puts "Введите номер добавляемой станции:"
      user_input = gets.chomp.to_i

      if (1..self.railway.stations.length).include?(user_input)
        if route.add_station(self.railway.stations[user_input - 1])
          puts "Станция #{self.railway.stations[user_input - 1].name} добавлена в маршрут"
        else
          puts "Станция #{self.railway.stations[user_input - 1].name} уже есть в маршруте"
        end
      else
        puts "Некорректный номер!"
      end
    else
      puts "Нет станций!"
    end
  end

  def delete_intermediate_station(route)
    puts "Удаление промежуточной станции"
    puts "Список станций маршрута:"
    route.route.each { |station| puts "#{route.route.index(station) + 1}) #{station.name}" }
    puts "Введите номер удаляемой станции:"
    user_input = gets.chomp.to_i

    if (1..route.route.length).include?(user_input)
      if route.delete_station(route.route[user_input - 1])
        puts "Станция удалена из маршрута"
      else
        puts "Ошибка! Станция #{self.railway.stations[user_input - 1].name} является начальной, либо конечной точкой!"
      end
    else
      puts "Некорректный номер!"
    end
  end
end
