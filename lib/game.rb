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