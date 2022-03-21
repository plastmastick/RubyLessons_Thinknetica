require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'railway'

def main_menu(railway)
  puts "__________\nУправление железной дорогой.\nГлавное меню."
  puts "\nВыберите номер опции:"
  puts "\n1) Управление станциями\n2) Управление поездами\n3) Управление маршрутами\n4) Выход из программы"
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
  puts "\n1) Создать станцию\n2) Список станций\n3) В главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1 #Создать станцию
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
  when 2 #Список станций
    if railway.stations.length > 0
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
    else
      puts "Нет станций!"
      station_menu(railway)
    end
  when 3 #Главное меню
    main_menu(railway)
  else
    puts "Неизвестная команда!"
    station_menu(railway)
  end
end

def station_submenu(railway, station)
  puts "__________\nМеню управлением станцией #{station.name}"
  puts "Количестов поездов: #{station.trains.length}"
  puts "\nВыберите номер опции:"
  puts "\n1) Список всех поездов\n2) Список грузовых поездов\n3) Список пассажирских поездов\n4) Меню управления станциями\n5) Главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1  #Список всех поездов
    if station.trains.length > 0
      puts "Список поездов:"
      station.trains.each { |train| puts "#{station.trains.index(train) + 1}) #{train.number} (#{train.type});" }
      puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        station_submenu(railway, station)
      elsif (1..railway.trains.length).include?(user_option)
        trains_submenu(railway, railway.trains[user_option - 1])
      else
        puts "Неизвестная команда!"
        station_submenu(railway, station)
      end
    else
      puts "Нет поездов!"
      station_submenu(railway, station)
    end
  when 2  #Список cargo поездов
    cargo_trains = station.show_trains_by_type("cargo")
    puts "Количество грузовых поездов: #{cargo_trains.length}"
    if cargo_trains.length > 0
      puts "Список поездов:"
      cargo_trains.each { |train| puts "#{cargo_trains.index(train) + 1}) #{train.number} (#{train.type});" }
      puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        station_submenu(railway, station)
      elsif (1..cargo_trains.length).include?(user_option)
        train_submenu(railway, cargo_trains[user_option - 1])
      else
        puts "Неизвестная команда!"
        station_submenu(railway, station)
      end
    else
      puts "Нет грузовых поездов!"
      station_submenu(railway, station)
    end
  when 3  #Список passenger поездов
    passenger_trains = station.show_trains_by_type("passenger")
    puts "Количество пассажирских поездов: #{passenger_trains.length}"
    if passenger_trains.length > 0
      puts "Список поездов:"
      passenger_trains.each { |train| puts "#{passenger_trains.index(train) + 1}) #{train.number} (#{train.type});" }
      puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        station_submenu(railway, station)
      elsif (1..passenger_trains.length).include?(user_option)
        train_submenu(railway, passenger_trains[user_option - 1])
      else
        puts "Неизвестная команда!"
        station_submenu(railway, station)
      end
    else
      puts "Нет пассажирских поездов!"
      station_submenu(railway, station)
    end
  when 4
    station_menu(railway)
  when 5
    main_menu(railway)
  end
end

def train_menu(railway)
  puts "__________\nМеню управлением поездами"
  puts "Количество поездов: #{railway.trains.length}"
  puts "\nВыберите номер опции:"
  puts "\n1) Создать пассажирский поезд\n2) Создать грузовой поезда\n3) Список поездов\n4) Выход в главное меню"
  user_option = gets.chomp.to_i

  case user_option
  when 1  #Создание пассажирского поезда
    railway.trains << PassengerTrain.new("P-#{railway.trains.length + 1}")
    puts "Добавлен поезд #{railway.trains.last.number}"
    train_menu(railway)
  when 2  #Создание грузового поезда
    railway.trains << CargoTrain.new("C-" + "#{railway.trains.length + 1}")
    puts "Добавлен поезд #{railway.trains.last.number}"
    train_menu(railway)
  when 3  #Список поездов
    if railway.trains.length > 0
      puts "Список поездов:"
      railway.trains.each { |train| puts "#{railway.trains.index(train) + 1}) #{train.number} (#{train.type});" }

      puts "\nВыберите порядковый номер поезда для управления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        main_menu(railway)
      elsif (1..railway.trains.length).include?(user_option)
        train_submenu(railway, railway.trains[user_option - 1])
      else
        puts "Неизвестная команда!"
        train_menu(railway)
      end
    else
      puts "Отсутствуют"
      train_menu(railway)
    end
  when 4  #Главное меню
    main_menu(railway)
  else  #Ошибка
    puts "Неизвестная команда!"
    train_menu(railway)
  end
end

def train_submenu(railway, train)
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
  when 1 #Назначить маршрут
    if railway.routes.length > 0
      puts "Список маршрутов:"
      railway.routes.each { |route| puts "#{railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name}"}

      puts "\nВыберите порядковый номер маршрута для назначения (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        train_submenu(railway, train)
      elsif (1..railway.routes.length).include?(user_option)
        train.set_route(railway.routes[user_option - 1])
        puts "Поезд #{train.number} движется по маршруту #{railway.routes[user_option - 1].route.first.name} -> #{railway.routes[user_option - 1].route.last.name}"
        train_submenu(railway, train)
      else
        puts "Неизвестная команда!"
        train_submenu(railway, train)
      end
    else
      puts "Нет маршрутов!"
      train_submenu(railway, train)
    end
  when 2 #Добавить вагон
    empty_wagons = railway.show_empty_wagons

    if empty_wagons.length > 0
      puts "Свободные вагоны:"
      empty_wagons.each { |wagon| puts "#{empty_wagons.index(wagon) + 1}) Вагон #{wagon.number}" }

      #Выбор вагона
      puts "\nВыберите вагон для прикрепления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        train_submenu(railway, train)
      elsif (1..empty_wagons.length).include?(user_option)
        if train.add_wagon(empty_wagons[user_option - 1])
          puts "Вагон #{empty_wagons[user_option - 1].number} прикреплен к поезду #{train.number}"
        else
          puts "Ошибка при прикреплении вагон!"
        end
        train_submenu(railway, train)
      else
        puts "Неизвестная команда!"
        train_submenu(railway, train)
      end
    else
      puts "Подходящие вагоны отсутствуют. Создать?\n1 - Да\n2 - Нет"
      user_option = gets.chomp.to_i

      case user_option
      when 1
        if train.type == "passenger"
          railway.wagons << PassengerWagon.new("PW-#{railway.wagons.length + 1}")
        elsif train.type == "cargo"
          railway.wagons << CargoWagon.new("CW-#{railway.wagons.length + 1}")
        end
        puts "Создан вагон #{railway.wagons.last.number} (Тип: #{railway.wagons.last.type})"
        train_submenu(railway, train)
      when 2
        train_submenu(railway, train)
      else
        puts "Неизвестная команда!"
        train_submenu(railway, train)
      end
    end
  when 3 #Отцепить вагон
    if train.wagons.length > 0
      puts "Список вагонов прикрепленных к поезду:"
      train.wagons.each { |wagon| puts "#{train.wagons.index(wagon) + 1}) Вагон №#{wagon.number}"}

      #Выбор вагона
      puts "\nВыберите вагон для отцепления (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        train_submenu(railway, train)
      elsif (1..train.wagons.length).include?(user_option)
        if train.remove_wagon(train.wagons[user_option - 1])
          puts "Вагон открелен от поезда #{train.number}"
        else
          puts "Ошибка при открпелении вагона!"
        end
        train_submenu(railway, train)
      else
        puts "Неизвестная команда!"
        train_submenu(railway, train)
      end
    else
      puts "Нет вагонов!"
      train_submenu(railway, train)
    end
  when 4 #Следующая станция
    if train.train_route != nil
      if train.current_station.send_train(train, true)
        puts "Поезд прибыл на станцию #{train.current_station.name}"
      else
        puts "Ошибка! Поезд не отправлен"
      end
    else
      puts "Маршрут не назначен"
    end
    train_submenu(railway, train)
  when 5 #Предыдущая станция
    if train.train_route != nil
      if train.current_station.send_train(train, false)
        puts "Поезд прибыл на станцию #{train.current_station.name}"
      else
        puts "Ошибка! Поезд не отправлен"
      end
    else
      puts "Маршрут не назначен"
    end
    train_submenu(railway, train)
  when 6 #Выход в главное меню
    main_menu(railway)
  else  #Ошибка
    puts "Неизвестная команда!"
    train_submenu(railway, train)
  end

end

def route_menu(railway)
  puts "__________\nМеню управлением маршрутам"
  puts "Количество маршрутов: #{railway.routes.length}"
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
      puts "\nВведите порядковый номер начальной станции из списка (0 для выхода):"
      user_input = gets.chomp.to_i

      if user_input == 0
        route_menu(railway)
      elsif (1..railway.stations.length).include?(user_input)
        first_station = railway.stations[user_input - 1]
      else
        puts "Неизвестная команда!"
        route_menu(railway)
      end

      puts "\nВведите порядковый номер конечной станции из списка (0 для выхода):"
      user_input = gets.chomp.to_i

      if user_input == 0
        route_menu(railway)
      elsif (1..railway.stations.length).include?(user_input)
        last_station = railway.stations[user_input - 1]
      else
        puts "Неизвестная команда!"
        route_menu(railway)
      end

      railway.routes << Route.new(first_station, last_station)
      route_menu(railway)
    else
      puts "Станции отсутствуют!"
      route_menu(railway)
    end
  when 2 #Список маршрутов
    if railway.routes.length != 0
      puts "Список маршрутов:"
      railway.routes.each { |route| puts "#{railway.routes.index(route) + 1}) Маршрут #{route.route.first.name} -> #{route.route.last.name} (Количество промежуточных станций: #{route.route.length - 2})" }

      puts "Введите порядковый номер маршрута (0 для выхода):"
      user_option = gets.chomp.to_i

      if user_option == 0
        route_menu(railway)
      elsif (1..railway.routes.length).include?(user_option)
        user_route = railway.routes[user_option - 1]
        puts "Маршрут #{user_route.route.first.name} -> #{user_route.route.last.name}"
        puts "\nВыберите опцию:\n1) Добавить промежуточную станцию\n2) Удалить промежуточную станцию\n3) Список станций в маршруте\n4) Выход в меню управления маршрутами"
        user_input = gets.chomp.to_i

        case user_input
        when 1  #Добавить промежуточную
          if railway.stations.length > 0
            puts "Список всех станций:"
            railway.stations.each { |station| puts "#{railway.stations.index(station) + 1}) #{station.name}" }
            puts "Введите номер добавляемой станции:"
            user_input = gets.chomp.to_i

            if (1..railway.stations.length).include?(user_input)
              if user_route.add_station(railway.stations[user_input - 1])
                puts "Станция #{railway.stations[user_input - 1].name} добавлена в маршрут"
              else
                puts "Станция #{railway.stations[user_input - 1].name} уже есть в маршруте"
              end
              route_menu(railway)
            else
              puts "Некорректный номер!"
              route_menu(railway)
            end
          else
            puts "Нет станций!"
            route_menu(railway)
          end
        when 2  #Удалить промежуточную
          puts "Список станций маршрута:"
          user_route.route.each { |station| puts "#{user_route.route.index(station) + 1}) #{station.name}" }
          puts "Введите номер удаляемой станции:"
          user_input = gets.chomp.to_i

          if (1..user_route.route.length).include?(user_input)
            if user_route.delete_station(user_route.route[user_input - 1])
              puts "Станция удалена из маршрута"
            else
              puts "Ошибка! Станция #{railway.stations[user_input - 1].name} является начальной, либо конечной точкой!"
            end
            route_menu(railway)
          else
            puts "Некорректный номер!"
            route_menu(railway)
          end
        when 3  #Список станций в маршруте
          puts "Список станций в маршруте:"
          user_route.route.each { |station| puts "#{user_route.route.index(station) + 1}) Станция #{station.name}"}
          route_menu(railway)
        when 4
          route_menu(railway)
        else  #Ошибка
          puts "Неизвестная команда"
          route_menu(railway)
        end
      else  #Ошибка
        puts "Неизвестная команда!"
        route_menu(railway)
      end
    else
      puts "Нет маршрутов!"
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
