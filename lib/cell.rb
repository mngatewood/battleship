class Cell

  attr_reader :coordinates
  
  attr_accessor :occupied, :strike

  def initialize(coordinates)
    @coordinates = coordinates
    @occupied = false
    @strike = nil
  end

end