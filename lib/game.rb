require './lib/board'
require './lib/ship'

class Game

  attr_reader :boards

  def initialize
    @boards = []
  end

  def create_computer_board
    computer = Board.new("Computer")
    @boards << computer
    computer.create_grid
  end

  def place_computer_ship(ship_name, length)
    computer_board = @boards.find{|board|board.name == "Computer"}
    direction = ["h", "v"].sample
    valid_cells = get_valid_placement_cells(length, direction)
    selected_cell = valid_cells.sample
    ship_location = get_ship_location(selected_cell, length, direction)
    ship = Ship.new(ship_name, ship_location)
    computer_board.place_ship(ship)
  end

  def get_valid_placement_cells(length, direction)
    computer_board = @boards.find{|board|board.name == "Computer"}
    temp_ship_location = get_ship_location("a1", length, direction)
    temp_ship = Ship.new("temp_ship", temp_ship_location)
    return computer_board.get_all_valid_cells(temp_ship)
  end
  
  def get_ship_location(start_coordinate, length, direction)
    Array(0..length - 1).map do |element|
      if direction == "h"
        start_coordinate[0] + (start_coordinate[1].to_i + element).to_s
      elsif direction == "v"
        (start_coordinate.ord + element).chr.downcase + start_coordinate[1]
      else
        "Invalid direction"
      end
    end
  end

end