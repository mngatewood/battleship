require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'

class BoardTest < Minitest::Test

  def test_it_exists
    board = Board.new("Player")
    assert_instance_of Board, board
  end

  def test_it_has_a_name
    board = Board.new("Player")
    assert_equal "Player", board.name
  end

  def test_it_starts_with_no_cells
    board = Board.new("Player")
    assert_equal [], board.cells
  end

  def test_it_can_add_a_cell
    board = Board.new("Player")
    cell = Cell.new("a1")
    board.add_cell(cell)
    assert_equal [cell], board.cells
  end

  def test_it_can_create_four_by_four_grid_of_cells
    board = Board.new("Player")
    board.create_grid
    assert_equal 16, board.cells.length
  end

  def test_it_starts_with_no_ships
    board = Board.new("Player")
    board.create_grid
    assert_equal [], board.ships
  end

  def test_it_can_place_a_ship
    board = Board.new("Player")
    ship = Ship.new("ship_1", ["a1", "a2"])
    board.create_grid
    board.place_ship(ship)
    assert_equal [ship], board.ships
  end

  def test_it_can_return_a_cell_with_coordinates
    board = Board.new("Player")
    board.create_grid
    cell = board.get_cell("a1")
    assert_instance_of Cell, cell
    assert_equal "a1", cell.coordinates
  end

  def test_it_occupies_a_cell_when_placing_a_ship
    board = Board.new("Player")
    board.create_grid
    ship = Ship.new("ship_1", ["a1", "a2"])
    board.place_ship(ship)
    cell_1 = board.get_cell("a1")
    cell_2 = board.get_cell("a2")
    cell_3 = board.get_cell("a3")
    assert cell_1.occupied
    assert cell_2.occupied
    refute cell_3.occupied
  end

end
