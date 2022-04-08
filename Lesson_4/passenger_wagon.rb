# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :max_seats, :occupied_seats

  validate :max_seats, :presence
  validate :max_seats, :comparison_min, 1

  def initialize(number, max_seats)
    self.max_seats = max_seats
    self.occupied_seats = 0
    super(number)
  end

  def take_seat
    self.occupied_seats += 1 if occupied_seats < max_seats
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
