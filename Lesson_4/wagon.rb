class Wagon
  attr_reader :type, :number
  attr_accessor :train

  def initialize(number)
    @number = number
    @type = wagon_type
    @train = nil
  end

  protected

  #Тип - константа класса
  def wagon_type
    "undefined"
  end
end
