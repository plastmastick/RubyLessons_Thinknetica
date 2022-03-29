class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :type, :speed, :number, :train_route, :current_station, :route_info, :wagons

  NAME_FORMAT = /^\w{3}([-]\w{2})?$/i

  @@trains = []

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    number_validate!

    register_instance
    @@trains << self
    @type = self.train_type
    @wagons = []
    @speed = 0
    @current_station = nil
    @train_route = nil
  end

  def increase_speed
    self.speed += 10
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    if self.speed == 0 && correct_wagon?(wagon) && !self.wagons.include?(wagon)
      self.wagons << wagon
      wagon.train=(self)
      true
    else
      false
    end
  end

  def remove_wagon(wagon)
    if self.speed == 0 && self.wagons.include?(wagon)
      self.wagons.delete(wagon)
      wagon.train=(nil)
      true
    else
      false
    end
  end

  def set_route(route)
    @train_route = route
    @current_station = @train_route.route[0]
    @current_station.add_train(self)
  end

  def next_station
    if @train_route.route.last != @current_station
      nearby_stations = self.route_info
      @current_station = nearby_stations[1]
      return false if !@current_station.add_train(self)
      true
    else
      false
    end
  end

  def previous_station
    if @train_route.route.first != @current_station
      nearby_stations = self.route_info
      @current_station = nearby_stations[0]
      return false if !@current_station.add_train(self)
      true
    else
      false
    end
  end

  def route_info
    route = @train_route.route
    @current_station != route.first ? previous_station = route[route.index(@current_station) - 1] : previous_station = nil
    @current_station != route.last ? next_station = route[route.index(@current_station) + 1] : next_station = nil
    return [previous_station, next_station]
  end

  def number_valid?
    number_validate!
    true
  rescue
    false
  end

  protected

  #Влиять на скорость можно только через методы
  attr_writer :speed, :wagons

  #Тип - константа класса, есть подклассы
  def train_type
    "undefined"
  end

  #Внутрення проверка, которая используется в подклассах
  def correct_wagon?(wagon)
    wagon.type == self.type && wagon.type != "undefined"
  end

  def number_validate!
    raise "Name can't be nil!" if @number.nil?
    raise "Name has invalid format!" if @number !~ NAME_FORMAT
  end
end
