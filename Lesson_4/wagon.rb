# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Accessors
  include Validation

  attr_reader :type, :number

  attr_accessor_with_history :train

  def initialize(number)
    @number = number
    validate! number, :presence
    @type = wagon_type
  end

  protected

  def wagon_type
    'undefined'
  end
end
