# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :max_seats, :occupied_seats

  def initialize(number, max_seats)
    super(number)
    @max_seats = max_seats
    seats_validate!
    @occupied_seats = 0
  end

  def take_seat
    self.occupied_seats += 1 if @occupied_seats < @max_seats
  end

  def empty_seats
    max_seats - self.occupied_seats
  end

  def seats_validate?
    seats_validate!
    true
  rescue StandardError
    false
  end

  protected

  attr_writer :occupied_seats

  def wagon_type
    'passenger'
  end

  def seats_validate!
    raise "Count of max places in wagon can't be nil or less then 1!" if @max_seats < 1 || @max_seats.nil?
  end
end
