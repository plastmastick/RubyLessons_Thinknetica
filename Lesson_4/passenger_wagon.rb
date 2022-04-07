# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :max_seats, :occupied_seats

  def initialize(number, max_seats)
    super(number)
    self.max_seats = max_seats
    validate! max_seats, :presence
    validate! max_seats, :comparison, '< 1'
    self.occupied_seats = 0
  end

  def take_seat
    validate!(@max_seats, :comparison, "< #{@occupied_seats + 1}")
    self.occupied_seats += 1
  end

  def empty_seats
    max_seats - self.occupied_seats
  end

  protected

  attr_writer :occupied_seats, :max_seats

  def wagon_type
    'passenger'
  end
end
