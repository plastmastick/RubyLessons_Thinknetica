# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :max_volume, :occupied_volume

  def initialize(number, max_volume)
    super(number)
    self.max_volume = max_volume
    validate! max_volume, :presence
    validate! max_volume, :comparison_min, 1
    self.occupied_volume = 0
  end

  def take_volume(volume)
    validate! volume, :presence
    validate! volume, :comparison_min, 1
    validate!(@max_volume, :compariso_min, @occupied_volume + 1)
    @occupied_volume += volume
  end

  def free_volume
    @max_volume - @occupied_volume
  end

  protected

  attr_writer :occupied_volume, :max_volume

  def wagon_type
    'cargo'
  end
end
