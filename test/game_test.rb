require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def test_it_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_it_starts_with_no_boards
    game = Game.new
    assert_equal [], game.boards
  end

  def test_it_can_create_a_computer_board
    game = Game.new
    game.create_computer_board
    assert_instance_of Board, game.boards[0]
    assert_equal "Computer", game.boards[0].name
    assert_equal 16, game.boards[0].cells.length
  end

  def test_it_can_create_a_player_board
    game = Game.new
    game.create_player_board
    assert_instance_of Board, game.boards[0]
    assert_equal "Player", game.boards[0].name
    assert_equal 16, game.boards[0].cells.length
  end

  def test_it_can_place_a_ship_at_random_location
    game = Game.new
    game.create_computer_board
    computer_board = game.boards.find{|board|board.name == "Computer"}
    game.place_computer_ship("small_ship", 2)
    assert_equal 1, computer_board.ships.length
    assert_equal "small_ship", computer_board.ships[0].name
    assert_equal 2, computer_board.ships[0].location.length
  end

  def test_it_can_return_an_array_of_valid_cells_for_ship_placement
    game = Game.new
    game.create_computer_board
    expected = ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3", "d1", "d2", "d3"]
    actual = game.get_valid_placement_cells(2, "h")
    assert_equal expected, actual

    expected = ["a1", "a2", "a3", "a4", "b1", "b2", "b3", "b4"]
    actual = game.get_valid_placement_cells(3, "v")
    assert_equal expected, actual
    
    expected = ["a1", "b1", "c1", "d1"]
    actual = game.get_valid_placement_cells(4, "h")
    assert_equal expected, actual
    
    expected = []
    actual = game.get_valid_placement_cells(5, "v")
    assert_equal expected, actual
  end

  def test_it_can_return_a_ship_location_given_start_length_and_direction
    game = Game.new
    game.create_computer_board
    expected = ["a1", "a2"]
    actual = game.get_ship_location("a1", 2, "h")
    assert_equal expected, actual

    expected = ["b2", "c2", "d2"]
    actual = game.get_ship_location("b2", 3, "v")
    assert_equal expected, actual
  end

  def test_it_knows_if_coordinates_are_valid
    game = Game.new
    game.create_computer_board
    board = game.boards[0]
    assert game.valid_coordinate?(board, "a1")
    refute game.valid_coordinate?(board, "a5")
  end

  def test_it_can_evaluate_a_shot
    game = Game.new
    game.create_computer_board
    board = game.boards[0]
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    board.place_ship(ship_1)
    target_cell = board.get_cell("a1")
    assert_equal "Miss", game.evaluate_shot(target_cell)

    target_cell = board.get_cell("c1")    
    assert_equal "Hit!", game.evaluate_shot(target_cell)

    target_cell = board.get_cell("a1")
    assert_equal "You already fired there.", game.evaluate_shot(target_cell)
  end

  def test_it_can_fire_torpedos
    game = Game.new
    game.create_computer_board
    game.create_player_board
    player_board = game.boards.find{|board|board.name == "Player"}
    computer_board = game.boards.find{|board|board.name == "Computer"}
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["c1", "d1"])
    player_board.place_ship(ship_1)
    computer_board.place_ship(ship_2)
    actual = game.fire_torpedos(computer_board, "a5")
    assert_equal "Invalid coordinate", actual

    actual = game.fire_torpedos(player_board, "d1")
    assert_equal "Miss", actual
  
    actual = game.fire_torpedos(player_board, "d1")
    assert_equal "You already fired there.", actual

    actual = game.fire_torpedos(computer_board, "d1")
    assert_equal "Hit!", actual
  end


end