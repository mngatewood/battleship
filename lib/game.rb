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

  def valid_placement_input?(input, length)
    array_length = input.length == length
    coord_length = input.map{|coordinate|coordinate.chars.length}.uniq == [2]
    coord_x = input.map{|coordinate|coordinate[1]}.join.count("0-9") == length
    coord_y = input.map{|coordinate|coordinate[0]}.join.count("a-z") == length
    return array_length && coord_length && coord_x && coord_y
  end

  def fire_torpedos(board, target_coordinate)
    if board.get_cell(target_coordinate)
      target_cell = board.get_cell(target_coordinate)
      shot_result = evaluate_shot(board, target_cell)
      return shot_result
    else
      return "Invalid coordinate"
    end
  end

  def evaluate_shot(board, target_cell)
    if target_cell.strike
      return "You already fired there."
    elsif target_cell.occupied
      target_cell.strike = "H"
      return board.evaluate_ship_status(target_cell.coordinates)
    else
      target_cell.strike = "M"
      return "Miss"
    end
  end

  def render_game_boards
    computer_board = @boards.find{|board|board.name == "Computer"}
    player_board = @boards.find{|board|board.name == "Player"}
    computer_board.render_board
    player_board.render_board
  end

end