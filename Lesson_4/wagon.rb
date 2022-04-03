# frozen_string_literal: true

class Wagon
  include Manufacturer

  attr_reader :type, :number
  attr_accessor :train

  def initialize(number)
    @number = number
    number_validate!
    @type = wagon_type
    @train = nil
  end

  def number_valid?
    number_validate!
    true
  rescue StandardError
    false
  end

  protected

  # Тип - константа класса
  def wagon_type
    'undefined'
  end

  def number_validate!
    raise "Name can't be nil!" if @number.nil?
  end
end
