class Railway
  attr_accessor :stations, :routes, :wagons, :trains

  def initialize
    @stations = []
    @routes = []
    @wagons = []
    @trains = []
  end

  def show_empty_wagons
    empty_wagons = []
    railway.wagons.each { |wagon| empty_wagons << wagon if wagon.train == nil }
    return empty_wagons
  end
end
