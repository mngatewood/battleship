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

end