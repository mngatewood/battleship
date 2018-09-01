class Cell

  attr_reader :coordinates,
              :occupied

  def initialize(coordinates)
    @coordinates = coordinates
    @occupied = false
  end

end