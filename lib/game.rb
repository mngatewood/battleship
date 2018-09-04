require './lib/board'
require './lib/ship'

class Game

  attr_reader :boards

  def initialize
    @boards = []
  end

  def create_board(player)
    board = Board.new(player)
    @boards << board
    board.create_grid
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

  def fire_torpedos(board, target_coordinate)
    if !valid_coordinate?(board, target_coordinate)
      return "Invalid coordinate"
    else
      target_cell = board.get_cell(target_coordinate)
      shot_result = evaluate_shot(board, target_cell)
      return shot_result
    end
  end

  def valid_coordinate?(board, target_coordinate) # move to board?
    cell_coordinates = board.cells.map{|cell|cell.coordinates}
    cell_coordinates.include?(target_coordinate)
  end

  def evaluate_shot(board, target_cell) # move to board?
    if target_cell.strike
      return "You already fired there."
    elsif target_cell.occupied
      target_cell.strike = "H"
      return evaluate_ship_status(board, target_cell.coordinates)
    else
      target_cell.strike = "M"
      return "Miss"
    end
  end

  def render_game_boards # move to board?
    computer_board = @boards.find{|board|board.name == "Computer"}
    player_board = @boards.find{|board|board.name == "Player"}
    computer_board.render_board
    player_board.render_board
  end

  def evaluate_ship_status(board, coordinate) # move to board or ship?
    ship = board.ships.find{|ship|ship.location.include?(coordinate)}
    strikes = ship.location.count do |coordinate|
      board.get_cell(coordinate).strike == "H"
    end
    if strikes == ship.location.length
      ship.sunk = true
      return "Hit! #{ship.name.capitalize} has been sunk!"
    else
      return "Hit!"
    end
  end

  def victory?(board) # move to board?
    sunken_ships = board.ships.count{|ship|ship.sunk}
    board.ships.length == sunken_ships
  end

end