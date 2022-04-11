# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Accessors
  include Validation

  attr_reader :type, :number

  attr_accessor_with_history :train
  validate :number, :persence

  def initialize(number)
    @number = number
    @type = wagon_type
    validate!
  end

  protected

  def wagon_type
    'undefined'
  end
end
