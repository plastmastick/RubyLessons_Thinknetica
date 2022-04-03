# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :max_volume, :occupied_volume

  def initialize(number, max_volume)
    super(number)
    @max_volume = max_volume
    volume_validate!
    @occupied_volume = 0
  end

  def take_volume(volume)
    take_volume_validate!(volume)
    @occupied_volume += volume if @occupied_volume < @max_volume
  end

  def free_volume
    @max_volume - @occupied_volume
  end

  def volume_validate?
    volume_validate!
    true
  rescue StandardError
    false
  end

  protected

  attr_writer :occupied_volume

  def wagon_type
    'cargo'
  end

  def volume_validate!
    raise "Count of max places in wagon can't be nil or less then 1!" if @max_volume < 1 || @max_volume.nil?
  end

  def take_volume_validate!(volume)
    raise "Volume can't be nil or less then 1!" if volume < 1 || volume.nil?
    raise "Not enought volume in wagon! Free volume: #{free_volume}" if @occupied_volume + volume > @max_volume
  end
end
