# frozen_string_literal: true

class Interface
  attr_reader :railway

  def initialize
    @railway = Railway.new
  end

  def main_menu
    puts "\n\nУправление железной дорогой.\nГлавное меню.\nВыберите номер опции:"
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
      create_passenger_wagon
    when 5
      create_cargo_wagon
    else
      puts 'Неизвестная команда!'
    end
    main_menu
  end

  def station_menu
    puts "\n\nМеню управление станциями."
    puts "\nВыберите номер опции:"
    puts "\n1) Создать станцию\n2) Список станций\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      create_station
    when 2
      show_stations
    else
      puts 'Неизвестная команда!'
    end
    station_menu
  end

  def station_submenu(station)
    puts "\nМеню управлением станцией #{station.name}"
    puts "Количестов поездов: #{station.trains.length}"

    puts "\nВыберите номер опции:"
    puts "\n1) Все поезда на станции\n2) Грузовые поезда\n3) Пассажирские поезда\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      show_trains('all', station)
    when 2
      show_trains('cargo', station)
    when 3
      show_trains('passenger', station)
    end

    station_submenu(station)
  end

  def train_menu
    puts "\n\nМеню управлением поездами"
    puts "\nВыберите номер опции:\n1) Создать пассажирский поезд\n2) Создать грузовой поезда"
    puts "3) Список поездов\n0) Выход в главное меню"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      create_train('passenger')
    when 2
      create_train('cargo')
    when 3
      show_trains('all')
    else
      puts 'Неизвестная команда!'
    end

    train_menu
  end

  def train_submenu(train)
    puts "\n\nМеню управлением поездом #{train.number}"

    show_train_route_info(train)

    puts "\nВыберите номер опции:"
    puts "1) Назначить маршрут\n2) Отправить вперед\n3) Отправить назад"
    puts "4) Управление вагонами\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      assign_train_route(train)
    when 2
      send_train(train, true)
    when 3
      send_train(train, false)
    when 4
      train_wagon_menu(train)
    else
      puts 'Неизвестная команда!'
    end

    train_submenu(train)
  end

  def train_wagon_menu(train)
    puts "\nУправление вагонами поезда #{train.number}"
    puts "Количество вагонов: #{train.wagons.length}"
    puts "\nВыберите номер опции:\n1) Добавить вагон\n2) Отцепить вагон\n3) Список вагонов"
    puts "4) Погрузка\n5) История прикрепленных поездов\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      add_train_wagon(train)
    when 2
      wagon_manipulate(train, 'delete')
    when 3
      show_wagons(train)
    when 4
      wagon_manipulate(train, 'loading')
    when 5
      wagon_manipulate(train, 'history')
    else
      puts 'Неизвестная команда'
    end
  end

  def route_menu
    puts "\n\nМеню управлением маршрутам"
    puts "Количество маршрутов: #{railway.routes.length}"
    puts "\nВыберите номер опции:"
    puts "\n1) Создать маршрут\n2) Список маршрутов\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      create_route
    when 2
      show_routes
      user_route = object_selection(railway.routes)
      return unless user_route.is_a? Route

      route_submenu(user_route)
    else
      puts 'Неизвестная команда!'
    end
  end

  def route_submenu(route)
    puts "\n\nМеню маршрута #{route.route.first.name} -> #{route.route.last.name}"
    puts "\nВыберите опцию:\n1) Добавить промежуточную станцию"
    puts "2) Удалить промежуточную станцию\n3) Список станций в маршруте\n0) Выход"
    user_option = gets.chomp.to_i
    return if user_option.zero?

    case user_option
    when 1
      add_intermediate_station(route)
    when 2
      delete_intermediate_station(route)
    when 3
      show_route_stations(route)
    else
      puts 'Неизвестная команда'
    end
  end

  private

  def object_selection(array)
    puts "\nВведите порядковый номер объекта (0 для выхода):"
    user_option = gets.chomp.to_i
    return if user_option.zero?
    return puts 'Неизвестная объект!' unless (1..array.length).include?(user_option)

    array[user_option - 1]
  end

  def create_station
    puts "\nВведите название станции (СТОП для выхода):"
    user_option = gets.chomp
    return if user_option.downcase == 'стоп'

    new_station = Station.new(user_option)
    railway.stations << new_station
    puts "\nДобавлена новая станция #{new_station.name}"
  end

  def show_stations(option = nil)
    return puts 'Нет станций!' if railway.stations.empty?

    puts 'Список станций:'
    railway.stations.each do |station|
      puts "#{railway.stations.index(station) + 1}) #{station.name};"
    end
    return if option == 'show'

    user_station = object_selection(railway.stations)
    return unless user_station.is_a? Station

    station_submenu(user_station)
  end

  def show_trains(type, station = nil)
    trains = railway.show_trains(type, station)
    return puts 'Нет поездов' if trains.empty?

    puts "\nСписок поездов:"
    trains.each do |train|
      print "#{trains.index(train) + 1}) #{train.number}"
      puts "(Тип #{train.type}, Количество вагонов: #{train.wagons.length});"
    end

    puts 'Номер поезда для управления'
    user_train = object_selection(trains)

    train_submenu(user_train) if user_train.is_a? Train
  end

  def create_train(type)
    puts 'Введите номер поезда(0 для выхода):'
    number = gets.chomp
    return if number.to_i.zero?

    railway.trains << CargoTrain.new(number) if type == 'cargo'
    railway.trains << PassengerTrain.new(number) if type == 'passenger'
    puts 'Добавлен новый поезд'
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    create_train(type)
  end

  def send_train(train, forward)
    return puts '\nМаршрут не назначен' if train.train_route.nil?

    train.current_station.send_train(train, forward)
    puts "Поезд прибыл на станцию #{train.current_station.name}"
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
  end

  def assign_train_route(train)
    return puts 'Нет маршрутов!' if railway.routes.empty?

    show_routes

    user_route = object_selection(railway.routes)
    return unless user_route.is_a? Route

    train.select_route(user_route)
    print "Поезд #{train.number} движется по маршруту "
    puts "#{user_route.route.first.name}-> #{user_route.route.last.name}"
  end

  def show_routes
    return puts 'Нет маршрутов!' if railway.routes.empty?

    routes = railway.routes

    puts 'Список маршрутов:'
    routes.each do |route|
      print "#{routes.index(route) + 1})"
      puts "Маршрут #{route.route.first.name} -> #{route.route.last.name}"
    end
  end

  def create_route
    show_stations('show')

    puts 'Начальная станция'
    first_station = object_selection(railway.stations)
    return unless first_station.is_a? Station

    puts 'Конечная станция'
    last_station = object_selection(railway.stations)
    return unless last_station.is_a? Station

    railway.routes << Route.new(first_station, last_station)
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    create_route
  end

  def add_intermediate_station(route)
    return puts 'Нет станций!' if railway.stations.empty?

    show_stations('show')

    user_route_station = object_selection(railway.stations)
    return unless user_route_station.is_a? Station

    route.add_station(user_route_station)
    puts "Станция #{user_route_station.name} добавлена в маршрут"
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def delete_intermediate_station(route)
    show_route_stations(route)

    user_route_station = object_selection(route.route)
    return unless user_route_station.is_a? Station

    route.delete_station(user_route_station)
    puts 'Станция удалена из маршрута'
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def show_route_stations(route)
    puts '\nСписок станций маршрута:'
    route.route.each { |station| puts "#{route.route.index(station) + 1}) #{station.name}" }
  end

  def create_cargo_wagon
    puts "\nВведите объем вагона:"
    user_value = gets.chomp.to_i

    railway.wagons << CargoWagon.new("CW-#{railway.wagons.length + 1}", user_value)

    puts "\nГрузовой вагон создан"
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    create_cargo_wagon
  end

  def create_passenger_wagon
    puts "\nВведите количество мест в вагоне:"
    user_value = gets.chomp.to_i

    railway.wagons << PassengerWagon.new("PW-#{railway.wagons.length + 1}", user_value)

    puts "\nПассажирский вагон создан"
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    create_passenger_wagon
  end

  def show_wagons(train)
    return puts 'Нет вагонов!' if train.wagons.empty?

    train.wagons_yield do |x|
      puts "#{train.wagons.index(x) + 1}) №#{x.number} Тип:#{x.type}"
      puts "  Объем #{x.occupied_volume}/#{x.max_volume}" if x.type == 'cargo'
      puts "  Количество мест #{x.occupied_seats}/#{x.max_seats}" if x.type == 'passenger'
    end
  end

  def wagon_manipulate(train, option)
    user_wagon = object_selection(train.wagons)
    return unless user_wagon.is_a? Wagon

    case option
    when 'loading'
      user_wagon.type == 'passenger' ? take_wagon_place(user_wagon) : take_wagon_volume(user_wagon)
    when 'delete'
      delete_train_wagon(train, user_wagon)
    when 'history'
      show_wagon_history(user_wagon)
    end
  end

  def add_train_wagon(train)
    empty_wagons = show_empty_wagons

    user_wagon = object_selection(empty_wagons)
    return unless user_wagon.is_a? Wagon

    train.add_wagon(user_wagon)
    puts "Вагон #{user_wagon.number} прикреплен к поезду #{train.number}"
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    add_train_wagon(train)
  end

  def show_empty_wagons
    empty_wagons = railway.empty_wagons
    return puts 'Нет подходящих вагонов!' if empty_wagons.empty?

    puts 'Свободные вагоны:'
    empty_wagons.each { |wagon| puts "#{empty_wagons.index(wagon) + 1}) Вагон #{wagon.number}" }

    empty_wagons
  end

  def delete_train_wagon(train, wagon)
    return puts 'Нет вагонов!' if train.wagons.empty?

    train.remove_wagon(wagon)
    puts "Вагон открелен от поезда #{train.number}"
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    delete_train_wagon(train)
  end

  def take_wagon_place(wagon)
    wagon.take_seat
    puts "\nЗанято 1 место. Количество мест #{wagon.occupied_seats}/#{wagon.max_seats}"
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    take_wagon_place(wagon)
  end

  def take_wagon_volume(wagon)
    puts "\nУкажите объем погрузки"
    user_value = gets.chomp.to_i
    wagon.take_volume(user_value)
    puts "\nПогрузка выполнена. Объем #{wagon.occupied_volume}/#{wagon.max_volume}"
  rescue RuntimeError => e
    puts "\nОшибка: #{e.message}"
    take_wagon_volume(wagon)
  end

  def show_train_route_info(train)
    return puts 'Маршрут не назначен' if train.train_route.nil?

    route_info = train.route_info
    previous_station = route_info[0].nil? ? '---' : route_info[0].name
    next_station = route_info[1].nil? ? '---' : route_info[1].name

    puts "Следующая станция: #{next_station}"
    puts "Текущая станция: #{train.current_station.name}"
    puts "Предыдущая станция: #{previous_station}"
  end

  def show_wagon_history(user_wagon)
    return puts 'Пустая история!' if user_wagon.train_history.empty?

    counter = 1
    user_wagon.train_history.each do |train|
      unless train.nil?
        puts "#{counter}) #{train.number}"
        counter += 1
      end
    end
  end
end
