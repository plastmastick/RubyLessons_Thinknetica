# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :max_volume, :occupied_volume

  validate :max_volume, :presence
  validate :max_volume, :comparison_min, 1

  def initialize(number, max_volume)
    @max_volume = max_volume
    @occupied_volume = 0
    super(number)
  end

  def take_volume(volume)
    take_volume_validate!(volume)
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

  def take_volume_validate!(volume)
    raise "Volume can't be nil or less then 1!" if volume < 1 || volume.nil?
    raise "Not enought volume in wagon! Free volume: #{free_volume}" if @occupied_volume + volume > @max_volume
  end
end
