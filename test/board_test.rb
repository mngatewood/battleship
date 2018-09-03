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

  def test_it_returns_coordinates_of_edge_columns_invalid_for_ship_placement
    board = Board.new("Player")
    board.create_grid
    length = 2
    expected = ["a4", "b4", "c4", "d4"]
    actual = board.get_invalid_columns(length)
    assert_equal expected, actual

    length = 3
    expected = ["a1", "a2", "b1", "b2", "c1", "c2", "d1", "d2"]
    actual = board.get_invalid_columns(length)
    assert_equal expected, actual
  end

  def test_it_returns_coordinates_of_edge_rows_invalid_for_ship_placement
    board = Board.new("Player")
    board.create_grid
    length = 2
    expected = ["d1", "d2", "d3", "d4"]
    actual = board.get_invalid_rows(length)
    assert_equal expected, actual

    length = 3
    expected = ["c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = board.get_invalid_rows(length)
    assert_equal expected, actual
  end

  def test_it_returns_coordinates_of_rows_and_columns_invalid_for_ship_placement
    board = Board.new("Player")
    board.create_grid
    length = 2
    direction = "h"
    expected = ["a4", "b4", "c4", "d4"]
    actual = board.get_invalid_edges(length, direction)
    assert_equal expected, actual

    length = 3
    direction = "v"
    expected = ["c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = board.get_invalid_edges(length, direction)
    assert_equal expected, actual

    length = 3
    direction = "a"
    expected = "Invalid parameters"
    actual = board.get_invalid_edges(length, direction)
    assert_equal expected, actual

    length = 1
    direction = "h"
    expected = "Invalid parameters"
    actual = board.get_invalid_edges(length, direction)
    assert_equal expected, actual
  end

  def test_it_can_return_occupied_cells
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["a2", "a3"])
    ship_2 = Ship.new("ship_2", ["b2", "b3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    expected = ["a2", "a3", "b2", "b3"]
    actual = board.get_occupied_cells
    assert_equal expected, actual
  end

  def test_it_can_determine_a_ships_direction
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["a2", "a3"])
    ship_2 = Ship.new("ship_2", ["b2", "c2", "d2"])
    ship_3 = Ship.new("ship_3", ["b2", "c3", "d4"])
    assert_equal "h", board.get_ship_direction(ship_1)
    assert_equal "v", board.get_ship_direction(ship_2)
    assert_equal "Invalid ship location", board.get_ship_direction(ship_3)
  end

  def test_it_can_return_coordinates_above_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c3", "d3"])
    expected = ["b1", "b2"]
    actual = board.get_coordinates_above_ship(ship_1, ship_2)
    assert_equal expected, actual
  end

  def test_it_can_return_coordinates_left_of_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c3", "d3"])
    ship_2 = Ship.new("ship_2", ["c1", "c2"])
    expected = ["c2", "d2"]
    actual = board.get_coordinates_left_of_ship(ship_1, ship_2)
    assert_equal expected, actual
  end

  def test_can_return_invalid_cells_before_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c3", "c4"])
    ship_2 = Ship.new("ship_2", ["c2", "d2"])
    ship_3 = Ship.new("ship_3", ["c1", "c2"])
    ship_4 = Ship.new("ship_4", ["a1", "b1"])
    ship_5 = Ship.new("ship_5", ["a1", "b1", "c1"])
    ship_6 = Ship.new("ship_6", ["a1", "b2"])
    expected = ["b3", "b4"]
    actual = board.get_invalid_cells_before_ship(ship_1, ship_2)
    assert_equal expected, actual

    expected = ["c2"]
    actual = board.get_invalid_cells_before_ship(ship_1, ship_3)
    assert_equal expected, actual

    expected = ["c1", "d1"]
    actual = board.get_invalid_cells_before_ship(ship_2, ship_3)
    assert_equal expected, actual   

    expected = ["b2"]
    actual = board.get_invalid_cells_before_ship(ship_2, ship_4)
    assert_equal expected, actual   

    expected = ["a3", "a4", "b3", "b4"]
    actual = board.get_invalid_cells_before_ship(ship_1, ship_5)
    assert_equal expected, actual   

    expected = "Invalid ship placement"
    actual = board.get_invalid_cells_before_ship(ship_1, ship_6)
    assert_equal expected, actual    
  end  

  def test_it_returns_true_if_array_elements_are_incremental
    board = Board.new("Player")
    array_1 = ["a", "b", "c"]
    array_2 = ["1", "2", "3"]
    array_3 = ["a", "c", "b"]
    array_4 = ["3", "2", "1"]
    assert board.array_incremental?(array_1)
    assert board.array_incremental?(array_2)
    refute board.array_incremental?(array_3)
    refute board.array_incremental?(array_4)
  end

  def test_it_returns_true_if_array_elements_are_identical
    board = Board.new("Player")
    array_1 = ["a", "a", "a"]
    array_2 = ["2", "2", "2"]
    array_3 = ["a", "a", "b"]
    array_4 = ["3", "2", "1"]
    assert board.array_identical?(array_1)
    assert board.array_identical?(array_2)
    refute board.array_identical?(array_3)
    refute board.array_identical?(array_4)
  end

  def test_it_can_return_invalid_cells_before_all_ships
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c3", "d3"])
    ship_3 = Ship.new("ship_3", ["a4", "b4", "c4"])
    board.place_ship(ship_1)
    expected = ["b1", "b2"]
    actual = board.get_invalid_cells_before_all_ships(ship_2)
    assert_equal expected, actual

    board.place_ship(ship_2)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3"]
    actual = board.get_invalid_cells_before_all_ships(ship_3)
    assert_equal expected, actual
  end

  def test_it_can_get_all_invalid_cells
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c3", "d3"])
    ship_3 = Ship.new("ship_3", ["a4", "b4", "c4"])
    ship_3 = Ship.new("ship_4", ["a1", "a2"])    
    expected = ["a4", "b4", "c4", "d4"]
    actual = board.get_all_invalid_cells(ship_1)
    assert_equal expected, actual

    board.place_ship(ship_1)
    expected = ["b1", "b2", "c1", "c2", "d1", "d2", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_2)
    assert_equal expected, actual

    board.place_ship(ship_2)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_3)
    assert_equal expected, actual

    board.place_ship(ship_3)
    expected = ["a3", "a4", "b3", "b4", "c3", "c4", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_4)
    assert_equal expected, actual
  end

end
