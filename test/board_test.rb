require './test/helper_test'
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
    ship = Ship.new("two_unit_ship", ["a1", "a2"])
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

  def test_it_knows_when_a_cell_is_invalid
    board = Board.new("Player")
    board.create_grid
    assert_nil board.get_cell("a5")
    assert_nil board.get_cell("e1")
    assert_nil board.get_cell("f8")
  end

  def test_it_occupies_a_cell_when_placing_a_ship
    board = Board.new("Player")
    board.create_grid
    ship = Ship.new("two_unit_ship", ["a1", "a2"])
    board.update_cell(ship)
    cell_1 = board.get_cell("a1")
    cell_2 = board.get_cell("a2")
    cell_3 = board.get_cell("a3")
    assert cell_1.occupied
    assert cell_2.occupied
    refute cell_3.occupied
  end

  def test_it_returns_out_of_bounds_cells_if_a_ship_is_out_of_bounds
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["d3", "d4"])
    ship_2 = Ship.new("two_unit_ship", ["d4", "d5"])
    ship_3 = Ship.new("three_unit_ship", ["c4", "d4", "e4"])
    ship_4 = Ship.new("two_unit_ship", ["d5", "d6"])
    assert_equal "", board.out_of_bounds_cells(ship_1)
    assert_equal "d5", board.out_of_bounds_cells(ship_2)
    assert_equal "e4", board.out_of_bounds_cells(ship_3)
    assert_equal "d5, d6", board.out_of_bounds_cells(ship_4)
  end

  def test_it_returns_occupied_cells_if_a_ship_is_placed_on_another_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["d3", "d4"])
    ship_2 = Ship.new("two_unit_ship", ["c4", "d4"])
    ship_3 = Ship.new("three_unit_ship", ["b3", "c3", "d3"])
    ship_4 = Ship.new("two_unit_ship", ["d2", "d3"])
    assert_equal "", board.occupied_cells(ship_1)
    
    board.place_ship(ship_1)
    assert_equal "d4", board.occupied_cells(ship_2)
    assert_equal "d3", board.occupied_cells(ship_3)
    assert_equal "d3", board.occupied_cells(ship_4)
  end

  def test_it_returns_an_error_if_ship_placement_is_invalid
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["d4", "d5"])
    ship_2 = Ship.new("two_unit_ship", ["d3", "d4"])
    ship_3 = Ship.new("three_unit_ship", ["b3", "c3", "d3"])
    ship_4 = Ship.new("two_unit_ship", ["a1", "b2"])
    ship_5 = Ship.new("two_unit_ship", ["a1", "a3"])
    ship_6 = Ship.new("three_unit_ship", ["b2", "c2", "d2"])
    expected = "Error. Cell(s) d5 is out of bounds."
    assert_equal expected, board.place_ship(ship_1)
    assert_equal [], board.ships

    assert board.place_ship(ship_2)
    assert_equal [ship_2], board.ships

    expected = "Error. Cell(s) d3 is occupied."
    assert_equal expected, board.place_ship(ship_3)
    assert_equal [ship_2], board.ships

    expected = "Error. Ships must be oriented vertically or horizontally."
    assert_equal expected, board.place_ship(ship_4)
    assert_equal [ship_2], board.ships

    expected = "Error. Ship coordinates must be contiguous (no gaps)."
    assert_equal expected, board.place_ship(ship_5)
    assert_equal [ship_2], board.ships

    assert board.place_ship(ship_6)
    assert_equal [ship_2, ship_6], board.ships
  end

  def test_it_does_not_return_an_error_if_ship_direction_is_valid
    board = Board.new("Player")
    ship_1 = Ship.new("two_unit_ship", ["d3", "d4"])
    rows = ship_1.location.map{|coordinate|coordinate[0]}
    columns = ship_1.location.map{|coordinate|coordinate[1]}
    actual = board.evaluate_invalid_ship_direction(ship_1, rows, columns)
    assert_equal "Ship is valid.", actual
  end

  def test_it_does_not_place_ships_out_of_bounds
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["d3", "d4"])
    ship_2 = Ship.new("two_unit_ship", ["d4", "d5"])
    ship_3 = Ship.new("two_unit_ship", ["d4", "e4"])
    ship_4 = Ship.new("two_unit_ship", ["d5", "d6"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    board.place_ship(ship_3)
    board.place_ship(ship_4)
    assert_equal [ship_1], board.ships
    assert_equal [ship_1], board.ships
    assert_equal [ship_1], board.ships
  end

  def test_it_can_place_a_ship_at_random_location
    board = Board.new("Computer")
    board.create_grid
    board.place_computer_ship("small_ship", 2)
    assert_equal 1, board.ships.length
    assert_equal "small_ship", board.ships[0].name
    assert_equal 2, board.ships[0].location.length
  end

  def test_it_can_return_an_array_of_valid_cells_for_ship_placement
    board = Board.new("Computer")
    board.create_grid
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", 
                "c1", "c2", "c3", "d1", "d2", "d3"]
    actual = board.get_valid_placement_cells(2, "h")
    assert_equal expected, actual

    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"]
    actual = board.get_valid_placement_cells(3, "v")
    assert_equal expected, actual
    
    expected = ["a1", "b1", "c1", "d1"]
    actual = board.get_valid_placement_cells(4, "h")
    assert_equal expected, actual
    
    expected = []
    actual = board.get_valid_placement_cells(5, "v")
    assert_equal expected, actual
  end

  def test_it_can_return_a_ship_location_given_start_length_and_direction
    board = Board.new("Computer")
    expected = ["a1", "a2"]
    actual = board.get_ship_location("a1", 2, "h")
    assert_equal expected, actual

    expected = ["b2", "c2", "d2"]
    actual = board.get_ship_location("b2", 3, "v")
    assert_equal expected, actual

    expected = "Invalid direction"
    actual = board.get_ship_location("b2", 3, "u")
    assert_equal expected, actual
  end

  def test_it_returns_coordinates_of_edge_columns_invalid_for_ship_placement
    board = Board.new("Player")
    board.create_grid
    length = 2
    expected = ["a4", "b4", "c4", "d4"]
    actual = board.get_invalid_rows_or_columns(length, 1)
    assert_equal expected, actual

    length = 3
    expected = ["a3", "a4", "b3", "b4", "c3", "c4", "d3", "d4"]
    actual = board.get_invalid_rows_or_columns(length, 1)
    assert_equal expected, actual
  end

  def test_it_returns_coordinates_of_edge_rows_invalid_for_ship_placement
    board = Board.new("Player")
    board.create_grid
    length = 2
    expected = ["d1", "d2", "d3", "d4"]
    actual = board.get_invalid_rows_or_columns(length, 0)
    assert_equal expected, actual

    length = 3
    expected = ["c1", "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = board.get_invalid_rows_or_columns(length, 0)
    assert_equal expected, actual
  end

  def test_it_returns_coordinates_of_rows_n_columns_invalid_for_ship_placement
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
    ship_1 = Ship.new("two_unit_ship", ["a2", "a3"])
    ship_2 = Ship.new("two_unit_ship", ["b2", "b3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    expected = ["a2", "a3", "b2", "b3"]
    actual = board.get_occupied_cells
    assert_equal expected, actual
  end

  def test_it_can_determine_a_ships_direction
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["a2", "a3"])
    ship_2 = Ship.new("three_unit_ship", ["b2", "c2", "d2"])
    ship_3 = Ship.new("three_unit_ship", ["b2", "c3", "d4"])
    assert_equal "h", board.get_ship_direction(ship_1)
    assert_equal "v", board.get_ship_direction(ship_2)
    expected = "Error. Ships must be oriented vertically or horizontally."
    actual = board.get_ship_direction(ship_3)
    assert_equal expected, actual 
  end

  def test_it_can_return_coordinates_above_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("two_unit_ship", ["c3", "d3"])
    expected = ["b1", "b2"]
    actual = board.get_coordinates_above_ship(ship_1, ship_2)
    assert_equal expected, actual
  end

  def test_it_can_return_coordinates_left_of_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c3", "d3"])
    ship_2 = Ship.new("two_unit_ship", ["c1", "c2"])
    expected = ["c2", "d2"]
    actual = board.get_coordinates_left_of_ship(ship_1, ship_2)
    assert_equal expected, actual
  end

  def test_can_return_invalid_cells_before_an_existing_ship
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c3", "c4"])
    ship_2 = Ship.new("two_unit_ship", ["c2", "d2"])
    ship_3 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_4 = Ship.new("two_unit_ship", ["a1", "b1"])
    ship_5 = Ship.new("three_unit_ship", ["a1", "b1", "c1"])
    ship_6 = Ship.new("two_unit_ship", ["a1", "b2"])
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
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("two_unit_ship", ["c3", "d3"])
    ship_3 = Ship.new("three_unit_ship", ["a4", "b4", "c4"])
    board.place_ship(ship_1)
    expected = ["b1", "b2"]
    actual = board.get_invalid_cells_before_all_ships(ship_2)
    assert_equal expected, actual

    board.place_ship(ship_2)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3"]
    actual = board.get_invalid_cells_before_all_ships(ship_3)
    assert_equal expected, actual
  end

  def test_it_can_return_all_invalid_cells
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("two_unit_ship", ["c3", "d3"])
    ship_3 = Ship.new("three_unit_ship", ["a4", "b4", "c4"])
    ship_4 = Ship.new("two_unit_ship", ["a1", "a2"])
    expected = ["a4", "b4", "c4", "d4"]
    actual = board.get_all_invalid_cells(ship_1)
    assert_equal expected, actual

    board.place_ship(ship_1)
    expected = ["b1", "b2", "c1", "c2", "d1", "d2", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_2)
    assert_equal expected, actual

    board.place_ship(ship_2)
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", 
                "c2", "c3", "c4", "d1", "d2", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_3)
    assert_equal expected, actual

    board.place_ship(ship_3)
    expected = ["a3", "a4", "b3", "b4", "c1", "c2", 
                "c3", "c4", "d2", "d3", "d4"]
    actual = board.get_all_invalid_cells(ship_4)
    assert_equal expected, actual
  end

  def test_it_can_return_all_valid_cells
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("two_unit_ship", ["c3", "d3"])
    ship_3 = Ship.new("three_unit_ship", ["a4", "b4", "c4"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    expected = ["a4", "b4"]
    actual = board.get_all_valid_cells(ship_3)
    assert_equal expected, actual
  end

  def test_it_can_get_the_display_value_of_a_player_cell
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    cell = board.get_cell("c1")
    assert_equal " ", board.player_cell_display_value(cell)

    board.place_ship(ship_1)
    assert_equal "S", board.player_cell_display_value(cell)

    cell.strike = "H"
    assert_equal "H", board.player_cell_display_value(cell)
  end

  def test_it_can_get_the_display_value_of_a_computer_cell
    board = Board.new("Computer")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    cell = board.get_cell("c1")
    assert_equal " ", board.computer_cell_display_value(cell)

    board.place_ship(ship_1)
    assert_equal " ", board.computer_cell_display_value(cell)

    cell.strike = "M"
    assert_equal "M", board.computer_cell_display_value(cell)
  end

  def test_it_can_get_the_display_value_of_a_player_or_computer_cell
    computer_board = Board.new("Computer")
    computer_board.create_grid
    computer_cell = computer_board.get_cell("c1")
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    assert_equal " ", computer_board.get_cell_value(computer_cell)
    
    player_board = Board.new("Player")
    player_board.create_grid
    player_cell = player_board.get_cell("c1")
    assert_equal " ", player_board.get_cell_value(player_cell)
    
    computer_board.place_ship(ship_1)
    assert_equal " ", computer_board.get_cell_value(computer_cell)

    player_board.place_ship(ship_1)
    assert_equal "S", player_board.get_cell_value(player_cell)

    computer_cell.strike = "H"
    assert_equal "H", computer_board.get_cell_value(computer_cell)

    player_cell.strike = "H"
    assert_equal "H", player_board.get_cell_value(player_cell)
  end

  def test_it_can_evaluate_ship_status_after_a_shot
    board = Board.new("Computer")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    board.place_ship(ship_1)
    board.get_cell("c1").strike = "H"
    assert_equal "Hit!", board.evaluate_ship_status("c1")
    board.get_cell("c2").strike = "H"
    expected = "Hit! Two_unit_ship has been sunk!"
    actual = board.evaluate_ship_status("c2")
    assert_equal expected, actual 
  end

  def test_it_knows_if_victory_condition_is_met
    board = Board.new("Computer")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("three_unit_ship", ["d1", "d2", "d3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    refute board.victory?
    ship_1.sunk = true
    refute board.victory?
    ship_2.sunk = true
    assert board.victory?
  end

  def test_it_can_render_board_heading
    board = Board.new("Computer")
    expected = "       COMPUTER       \n--------------------\n   | 1 | 2 | 3 | 4 |\n"
    assert_output(expected) {board.render_board_heading}
  end

  def test_it_can_render_board_rows
    board = Board.new("Computer")
    board.create_grid
    rows = board.cells.map {|cell|cell.coordinates[0]}.uniq.sort
    columns = board.cells.map {|cell|cell.coordinates[1]}.uniq.sort

    expected = " A |   |   |   |   |\n B |   |   |   |   |\n C |   |   |   |   |\n D |   |   |   |   |\n"
    assert_output(expected) {board.get_board_rows(rows, columns)}
  end

  def test_it_can_render_a_player_board
    board = Board.new("Player")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("three_unit_ship", ["d1", "d2", "d3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    board.get_cell("c1").strike = "H"
    board.get_cell("a1").strike = "M"
    board.get_cell("d1").strike = "H"
    board.get_cell("b4").strike = "M"
    expected = "       PLAYER       \n--------------------\n   | 1 | 2 | 3 | 4 |\n A | M |   |   |   |\n B |   |   |   | M |\n C | H | S |   |   |\n D | H | S | S |   |\n\n"
    assert_output(expected) {board.render_board}
  end

  def test_it_can_render_a_computer_board
    board = Board.new("Computer")
    board.create_grid
    ship_1 = Ship.new("two_unit_ship", ["c1", "c2"])
    ship_2 = Ship.new("three_unit_ship", ["d1", "d2", "d3"])
    board.place_ship(ship_1)
    board.place_ship(ship_2)
    board.get_cell("c1").strike = "H"
    board.get_cell("a1").strike = "M"
    board.get_cell("d1").strike = "H"
    board.get_cell("b4").strike = "M"
    expected = "       COMPUTER       \n--------------------\n   | 1 | 2 | 3 | 4 |\n A | M |   |   |   |\n B |   |   |   | M |\n C | H |   |   |   |\n D | H |   |   |   |\n\n"
    assert_output(expected) {board.render_board}
  end

end
