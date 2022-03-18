require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'railway'

=begin
pwagon1 = PassengerWagon.new("PW-01")
pwagon2 = PassengerWagon.new("PW-02")

cwagon1 = CargoWagon.new("CW-01")
cwagon2 = CargoWagon.new("CW-02")

ptrain1 = PassengerTrain.new("P-001")
ptrain2 = PassengerTrain.new("P-002")

ctrain1 = CargoTrain.new("C-001")
ctrain2 = CargoTrain.new("C-002")

station1 = Station.new("Moscow")
station2 = Station.new("Yaroslavl")
station3 = Station.new("SPB")
station4 = Station.new("Kazan")

route1 =  Route.new(station1, station3)
route2 = Route.new(station1, station4)

ptrain1.set_route(route1)
ptrain1.add_wagon(pwagon1)
=end

def main_menu(railway)
  puts "__________\nУправление железной дорогой.\nГлавное меню."
  puts "\nВыберите номер опции:"
  puts "\n1) Управление станциями\n2) Управление поездами\n3) Управление маршрутами\n4) Выход"
  user_option = gets.chomp.to_i

  case user_option
  when 1
    station_menu(railway)
  when 2
    train_menu(railway)
  when 3
    route_menu(railway)
  when 4
    return
  else
    puts "Неизвестная команда!"
    main_menu(railway)
  end
end

def station_menu(railway)
  puts "__________\nУправление железной дорогой.\nМеню управление станциями."
  puts "\nВыберите номер опции:"
  puts "\n1) Создать станцию\n2) Список станций\n3) Выход"
  user_option = gets.chomp.to_i

  case user_option
  when 1
    puts "\nВведите название станции (СТОП для выхода):"
    user_input = gets.chomp

    case user_input.downcase
    when "стоп"
      station_menu(railway)
    else
      new_station = Station.new(user_input)
      railway.stations << new_station
      puts "\nДобавлена новая станция #{new_station.name}"
      station_menu(railway)
    end
  when 2
    puts "Список станций:"
    railway.stations.each { |station| puts "#{railway.stations.index(station) + 1}) #{station.name} (Количество поездов: #{station.trains.length});" }

    puts "Для управления нужной станцией введите её порядковый номер (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      station_menu(railway)
    elsif (1..railway.stations.length).include?(user_option)
      station_submenu(railway, railway.stations[user_option - 1])
    else
      puts "Неизвестная команда!"
      station_menu(railway)
    end
  when 3
    main_menu(railway)
  else
    puts "Неизвестная команда!"
    station_menu(railway)
  end
end

def station_submenu(railway, station)
  puts "Меню управлением станцией #{station.name}"
  puts "Количестов поездов: #{station.trains.length}"
  puts "\nВыберите номер опции:"
  puts "\n1) Список всех поездов\n2) Список грузовых поездов\n3) Список пассажирских поездов\n4) Выход"
  user_option = gets.chomp.to_i

  case user_option
  when 1
    puts "Список поездов:"
    station.trains.each { |train| puts "#{station.trains.index(train) + 1}) №#{train.number} (#{train.type});" }
    puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      main_menu(railway)
    elsif (1..railway.trains.length).include?(user_option)
      trains_submenu(railway, railway.trains[user_option - 1])
    else
      puts "Неизвестная команда!"
      station_submenu(railway)
    end
  when 2
    cargo_trains = station.show_trains_by_type("cargo")
    puts "Количество грузовых поездов: #{cargo_trains.length}"
    puts "Список поездов:"
    cargo_trains.each { |train| puts "#{cargo_trains.trains.index(train) + 1}) №#{train.number} (#{train.type});" }
    puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      main_menu(railway)
    elsif (1..cargo_trains.length).include?(user_option)
      trains_submenu(railway, cargo_trains[user_option - 1])
    else
      puts "Неизвестная команда!"
      station_submenu(railway)
    end
  when 3
    passenger_trains = station.show_trains_by_type("passenger")
    puts "Количество пассажирских поездов: #{passenger_trains.length}"
    puts "Список поездов:"
    passenger_trains.each { |train| puts "#{passenger_trains.trains.index(train) + 1}) №#{train.number} (#{train.type});" }
    puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      main_menu(railway)
    elsif (1..passenger_train.length).include?(user_option)
      trains_submenu(railway, passenger_train[user_option - 1])
    else
      puts "Неизвестная команда!"
      station_submenu(railway)
    end
  when 4
    #проверить корректность вызова
    station_menu(railway)
  end
end

def train_menu(railway)
  puts "Меню управлением поездами"
  puts "Количество поездов: #{railway.trains.length}"
  puts "\nВыберите номер опции:"
  puts "\n1) Создать поезд\n2) Список поездов\n3) Выход в главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1  #Создание поезда
    puts "Введите номер поезда (СТОП - выход):"
    user_input = gets.chomp
    if user_input.downcase == "стоп"
      train_menu(railway)
    else
      puts "Выберите тип поезда (1 - Пассажирский, 2 - Грузовой)"
      user_train_type = gets.chomp
      case user_train_type
      when 1  #Пассажирский
        railway.trains << PassengerTrain(user_input)
        train_menu(railway)
      when 2  #Грузовой
        railway.trains << CargoTrain(user_input)
        train_menu(railway)
      else  #Ошибка
        puts "Некорректая команда"
        train_menu(railway)
      end
    end
  when 2  #Список поездов
    puts "Список поездов:"
    railway.trains.each { |train| puts "#{railway.trains.index(train) + 1}) №#{train.number} (#{train.type});" }

    puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      main_menu(railway)
    elsif (1..railway.trains.length).include?(user_option)
      trains_submenu(railway, railway.trains[user_option - 1])
    else
      puts "Неизвестная команда!"
      train_menu(railway)
    end
  when 3  #Главное меню
    main_menu(railway)
  else  #Ошибка
    puts "Неизвестная команда!"
    train_menu(railway)
  end
end

def train_submenu(railway, train)
  puts "Меню управлением поездом #{train.number}"
  puts "Текущая станция: #{train.current_station.name}" if train.current_station != nil
  puts "Количество вагонов: #{trains.wagons.length}"
  if train.train_route != nil
    route_info = trains.route_info
    puts "Следующая станция: #{route_info[0].name}\nПредыдущая станция: #{route_info[1].name}"
  else
    puts "Маршрут не назначен"
  end

  puts "\nВыберите номер опции:"
  puts "\n1) Назначить маршрут\n2) Добавить вагон\n3) Отцепить вагон\n4) Отправить поезд вперед\n5) Отправить поезд назад\n6) Выход в главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1 #Назначить маршрут
    #Добавить проверку на пустоту
    puts "Список маршрутов:"
    railway.routes.each { |route| puts "#{railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name}"}

    puts "\nВыберите порядковый номер маршрута для назначения (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      train_submenu(railway, train)
    elsif (1..railway.routes.length).include?(user_option)
      railway.trains(train).set_route(railway.routes[user_option - 1])
      puts "Поезд №#{train.number} движется по маршруту #{railway.routes[user_option].route.first.name} -> #{railway.routes[user_option]..route.last.name}"
    else
      puts "Неизвестная команда!"
      train_menu(railway)
    end
  when 2 #Добавить вагон
    #Показать список доступных вагонов
    suitable_wagons = []
    railway.show_empty_wagons.each { |wagon| suitable_wagons << wagon if train.correct_wagon?(wagon) }
    puts "Подходящие вагоны:"
    suitable_wagons.each { |wagon| puts "#{suitable_wagons.index(wagon) + 1}) Вагон №#{wagon.number}" }

    #Выбор вагона
    puts "\nВыберите вагон для добавления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      train_submenu(railway, train)
    elsif (1..suitable_wagons.length).include?(user_option)
      train.add_wagon(suitable_wagons[user_option - 1])
      puts "Вагон №#{suitable_wagons[user_option - 1].number} прикреплен к поезду #{train.number}"
      train_submenu(railway, train)
    else
      puts "Неизвестная команда!"
      train_submenu(railway, train)
    end
  when 3 #Отцепить вагон
    puts "Список вагонов прикрепленных к поезду:"
    train.wagons.each { |wagon| puts "#{train.wagons.index(wagon) + 1}) Вагон №#{wagon.number}"}

    #Выбор вагона
    puts "\nВыберите вагон для отцепления (0 для выхода):"
    user_option = gets.chomp.to_i

    if user_option == 0
      train_submenu(railway, train)
    elsif (1..train.wagons.length).include?(user_option)
      train.remove_wagon(train.wagons[user_option - 1])
      puts "Вагон №#{train.wagons[user_option - 1].number} открелен от поезда #{train.number}"
      train_submenu(railway, train)
    else
      puts "Неизвестная команда!"
      train_submenu(railway, train)
    end
  when 4 #Следующая станция
    if train.train_route != nil
      route_info = trains.route_info
      puts "Поезд отбывает от станции #{train.current_station.name} на станцию #{route_info[1].name}"
      train.current_station.send_train(train, true)
      puts "Поезд прибыл на станцию #{train.current_station.name}"
    elsif train.train_route == nil
      puts "Маршрут не назначен"
    end
  when 5 #Предыдущая станция
    if train.train_route != nil
      route_info = trains.route_info
      puts "Поезд отбывает от станции #{train.current_station.name} на станцию #{route_info[0].name}"
      train.current_station.send_train(train, false)
      puts "Поезд прибыл на станцию #{train.current_station.name}"
    elsif train.train_route == nil
      puts "Маршрут не назначен"
    end
  when 6 #Выход в главное меню
    main_menu(railway)
  else  #Ошибка
    puts "Неизвестная команда!"
    train_submenu(railway, train)
  end

end

def route_menu(railway)
  puts "Меню управлением маршрутам"
  puts "\nВыберите номер опции:"
  puts "\n1) Создать маршрут\n2) Список маршрутов\n3) Выход в главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1 #Создание маршрута
    first_station = nil
    last_station = nil
    if railway.stations.length != 0
      puts "Список станций:"
      railway.stations.each { |station| puts "#{railway.stations.index(station) + 1}) #{station.name} (Количество поездов: #{station.trains.length});" }

      #выбор станции
      puts "\nВведите название начальной станции (СТОП для выхода):"
      user_input = gets.chomp

      case user_input.downcase
      when "стоп"
        route_menu(railway)
      else
        first_station = user_input
      end

      puts "\nВведите название конечной станции (СТОП для выхода):"
      user_input = gets.chomp

      case user_input.downcase
      when "стоп"
        route_menu(railway)
      else
        last_station = user_input
      end

      railway.routes << Routes.new(first_station, last_station)
      route_menu(railway)
    else
      puts "Станции отсутствуют"
      route_menu(railway)
    end
  when 2 #Список маршрутов
    if railway.routes.length != 0
      puts "Список маршрутов:"
      railway.routes.each { |route| puts "#{railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name} (Количество промежуточных станций: #{route.route.length - 2})" }

      puts "Введите порядковый номер маршрута:"
      user_option = gets.chomp.to_i

      if user_option == 0
        route_menu(railway)
      elsif (1..railway.routes.length).include?(user_option)
        user_route = railway.routes[user_option - 1]
        puts "Маршрут #{user_route.route.first.name} -> #{user_route.route.last.name}"
        puts "Выберите опцию:\n1)Добавить промежуточную станцию\n2)Удалить промежуточную станцию\n3)Выход"
        user_input = gets.chomp.to_i

        case user_input
        when 1  #Добавить промежуточную
          puts "Список всех станций:"
          railway.stations.each { |station| puts "#{railway.stations.index(station) + 1}) #{station.name}" }
          puts "Введите номер добавляемой станции:"
          user_input = gets.chomp.to_i

          if (1..railway.stations.length).include?(user_input) && !user_route.route.include?(railway.stations[user_input - 1])
            user_route.add_station(railway.stations[user_input - 1])
            puts "Станция добавлена в маршрут"
            route_menu(railway)
          else
            puts "Некорректный номер"
            route_menu(railway)
          end
        when 2  #Добавить промежуточную
          puts "Список станций маршрута:"
          user_route.route.each { |station| puts "#{user_route.route.index(station) + 1}) #{station.name}" }
          puts "Введите номер удаляемой станции:"
          user_input = gets.chomp.to_i

          if (1..user_route.route.length).include?(user_input)
            user_route.delete_station(user_route.route[user_input - 1])
            puts "Станция удалена из маршрута"
            route_menu(railway)
          else
            puts "Некорректный номер"
            route_menu(railway)
          end
        else  #Ошибка
          puts "Неизвестная команда"
          route_menu(railway)
        end
      else  #Ошибка
        puts "Неизвестная команда!"
        route_menu(railway)
      end
    else
      puts "Список маршрутов: Отсутствуют"
      route_menu(railway)
    end
  when 3 #Выход в главное меню
    main_menu(railway)
  else  #Ошибка
    puts "Неизвестная команда!"
    route_menu(railway)
  end
end

railway = Railway.new
main_menu(railway)
