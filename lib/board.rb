require './lib/cell'
require 'pry'

class Board

  attr_reader :name,
              :cells

  def initialize(name)
    @name = name
    @cells = []
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
    binding.pry
  end

end