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
    board.update_cell(ship)
    cell_1 = board.get_cell("a1")
    cell_2 = board.get_cell("a2")
    cell_3 = board.get_cell("a3")
    assert cell_1.occupied
    assert cell_2.occupied
    refute cell_3.occupied
  end

  def test_it_knows_if_a_ship_is_out_of_bounds
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["d3", "d4"])
    ship_2 = Ship.new("ship_2", ["d4", "d5"])
    ship_3 = Ship.new("ship_3", ["d4", "e4"])
    ship_4 = Ship.new("ship_4", ["d5", "d6"])
    assert board.valid_location?(ship_1)
    refute board.valid_location?(ship_2)
    refute board.valid_location?(ship_3)
    refute board.valid_location?(ship_4)
  end

  def test_it_does_not_place_ships_out_of_bounds
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["d3", "d4"])
    ship_2 = Ship.new("ship_2", ["d4", "d5"])
    ship_3 = Ship.new("ship_3", ["d4", "e4"])
    ship_4 = Ship.new("ship_4", ["d5", "d6"])
    assert board.place_ship(ship_1)
    refute board.place_ship(ship_2)
    refute board.place_ship(ship_3)
    refute board.place_ship(ship_4)
    assert_equal [ship_1], board.ships
  end

  def test_it_eliminates_edge_columns_from_valid_ship_locations
    board = Board.new("Player")
    board.create_grid
    length = 2
    cells = board.eliminate_invalid_columns(length)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3", "d1", "d2", "d3"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    length = 3
    cells = board.eliminate_invalid_columns(length)
    expected = ["a1", "a2", "b1", "b2", "c1", "c2", "d1", "d2"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual
  end

  def test_it_eliminates_edge_rows_from_valid_ship_locations
    board = Board.new("Player")
    board.create_grid
    length = 2
    cells = board.eliminate_invalid_rows(length)
    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4", "c1", "c2", "c3", "c4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    length = 3
    cells = board.eliminate_invalid_rows(length)
    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual
  end

  def test_it_can_eliminate_invalid_rows_and_columns_from_valid_ship_locations
    board = Board.new("Player")
    board.create_grid
    length = 2
    direction = "h"
    cells = board.eliminate_invalid_edges(length, direction)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3", "d1", "d2", "d3"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    length = 3
    direction = "v"
    cells = board.eliminate_invalid_edges(length, direction)
    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    length = 3
    direction = "a"
    cells = board.eliminate_invalid_edges(length, direction)
    expected = "invalid parameters"
    assert_equal expected, cells

    length = 1
    direction = "h"
    cells = board.eliminate_invalid_edges(length, direction)
    expected = "invalid parameters"
    assert_equal expected, cells
  end

  def test_it_can_eliminate_occupied_cells
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["a2", "a3"])
    ship_2 = Ship.new("ship_2", ["b2", "b3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    cells = board.eliminate_occupied_cells
    expected = ["a1", "a4", "b1", "b4", "c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual
  end

  def test_it_can_determine_a_ships_direction
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["a2", "a3"])
    ship_2 = Ship.new("ship_2", ["b2", "c2", "d2"])
    ship_3 = Ship.new("ship_3", ["b2", "c3", "d4"])
    assert_equal "h", board.determine_ship_direction(ship_1)
    assert_equal "v", board.determine_ship_direction(ship_2)
    assert_equal "Invalid ship location", board.determine_ship_direction(ship_3)
  end

  def test_it_can_return_coordinates_above_an_existing_horizontal_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    length = 2
    expected = ["a1", "a2", "b1", "b2"]
    actual = board.get_coordinates_above_ships(ship_1.location, length)
    assert_equal expected, actual
  end

  def test_it_can_return_coordinates_left_of_an_existing_vertical_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c3", "d3"])
    length = 2
    expected = ["c1", "c2", "d1", "d2"]
    actual = board.get_coordinates_left_of_ships(ship_1.location, length)
    assert_equal expected, actual
  end

  def test_can_return_invalid_cells_before_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c3", "d3"])
    ship_3 = Ship.new("ship_3", ["a4", "b4", "c4"])
    ship_4 = Ship.new("ship_4", ["a1", "b2"])
    length_of_new_ship = 2
    expected = ["a1", "a2", "b1", "b2"]
    actual = board.get_invalid_cells_before_ships(ship_1, length_of_new_ship)
    assert_equal expected, actual

    length_of_new_ship = 3
    expected = ["c1", "c2", "d1", "d2"]
    actual = board.get_invalid_cells_before_ships(ship_2, length_of_new_ship)
    assert_equal expected, actual

    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3"]
    actual = board.get_invalid_cells_before_ships(ship_3, length_of_new_ship)
    assert_equal expected, actual   

    expected = "Invalid ship placement"
    actual = board.get_invalid_cells_before_ships(ship_4, length_of_new_ship)
    assert_equal expected, actual    
  end  

  def test_can_eliminate_cells_before_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c3", "d3"])
    ship_3 = Ship.new("ship_3", ["a4", "b4", "c4"])
    ship_4 = Ship.new("ship_4", ["a1", "b2"])
    length_of_new_ship = 2
    cells = board.eliminate_cells_before_ships(ship_1, length_of_new_ship)
    expected = ["a3", "a4", "b3", "b4", "c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    length_of_new_ship = 3
    cells = board.eliminate_cells_before_ships(ship_2, length_of_new_ship)
    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4", "c3", "c4", "d3", "d4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    cells = board.eliminate_cells_before_ships(ship_3, length_of_new_ship)
    expected = ["a4", "b4", "c4", "d1", "d2", "d3", "d4"]
    actual = cells.map{|cell|cell.coordinates}
    assert_equal expected, actual

    expected = "Invalid ship placement"
    actual = board.eliminate_cells_before_ships(ship_4, length_of_new_ship)
    assert_equal expected, actual    
  end  

end
