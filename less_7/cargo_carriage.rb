class CargoCarriage < Carriage
  attr_accessor :volume, :number_free_vol

  def initialize(volume)
    super
    @volume = volume
    @number_free_vol = volume
  end

  def occupy_volume(vol)
    @number_free_vol -= vol if @number_free_vol > 0 && @number_free_vol > vol
  end

  def occupied_volume
    @volume - @number_free_vol
  end

  protected

  def initial_type
    @type = 'cargo'
  end
end
