class Ship

  attr_reader :name,
              :location

  attr_accessor :sunk

  def initialize(name, location)
    @name = name
    @location = location
    @sunk = false
  end

end