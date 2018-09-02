require './lib/cell'
require './lib/ship'
require 'pry'

class Board

  attr_reader :name,
              :cells,
              :ships

  def initialize(name)
    @name = name
    @cells = []
    @ships = []
  end

  def add_cell(cell)
    @cells << cell
  end

  def create_grid
    letters = ["a", "b", "c", "d"]
    numbers = ["1", "2", "3", "4"]
    letters.each do |letter|
      numbers.each do |number|
        coordinates = letter + number
        cell = Cell.new(coordinates)
        add_cell(cell)
      end
    end
  end

  def place_ship(ship)
    if valid_location?(ship)
      update_cell(ship)
      @ships << ship
      return true
    else
      return false
    end
  end

  def update_cell(ship)
    ship.location.each do |coordinate|
      get_cell(coordinate).occupied = true
    end
  end

  def get_cell(coordinates)
    @cells.find{|cell|cell.coordinates == coordinates}
  end

  def valid_location?(ship)
    cell_coordinates = @cells.map{|cell|cell.coordinates}
    (ship.location - cell_coordinates).empty?
  end

end