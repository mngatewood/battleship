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

  def create_player_board
    player = Board.new("Player")
    @boards << player
    player.create_grid
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

  def fire_torpedos(board, target_coordinate) #untested
    if !valid_coordinate?(board, target_coordinate)
      return "Invalid coordinate"
    else
      target_cell = board.get_cell(target_coordinate)
      shot_result = evaluate_shot(target_cell)
      return shot_result
    end
  end

  def valid_coordinate?(board, target_coordinate)
    cell_coordinates = board.cells.map{|cell|cell.coordinates}
    cell_coordinates.include?(target_coordinate)
  end

  def evaluate_shot(target_cell)
    if target_cell.strike
      return "You already fired there."
    elsif target_cell.occupied
      target_cell.strike = "H"
      return "Hit!"
    else
      target_cell.strike = "M"
      return "Miss"
    end
  end

end