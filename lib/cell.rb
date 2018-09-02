class Cell

  attr_reader :coordinates
  
  attr_accessor :occupied

  def initialize(coordinates)
    @coordinates = coordinates
    @occupied = false
  end

end