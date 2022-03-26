require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'railway'
require_relative 'interface'

def start
  new_interface = Interface.new
  new_interface.main_menu
end
