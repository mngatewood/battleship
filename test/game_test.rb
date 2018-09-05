require './test/helper_test'
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

  def test_it_can_create_a_board
    game = Game.new
    game.create_board("Computer")
    assert_instance_of Board, game.boards[0]
    assert_equal "Computer", game.boards[0].name
    assert_equal 16, game.boards[0].cells.length

    game.create_board("Player")
    assert_instance_of Board, game.boards[1]
    assert_equal "Player", game.boards[1].name
    assert_equal 16, game.boards[1].cells.length
  end


  def test_it_can_evaluate_a_shot
    game = Game.new
    game.create_board("Computer")
    board = game.boards[0]
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    board.place_ship(ship_1)
    target_cell = board.get_cell("a1")
    assert_equal "Miss", game.evaluate_shot(board, target_cell)

    target_cell = board.get_cell("c1")    
    assert_equal "Hit!", game.evaluate_shot(board, target_cell)

    target_cell = board.get_cell("a1")
    assert_equal "You already fired there.", game.evaluate_shot(board, target_cell)
  end

  def test_it_can_fire_torpedos
    game = Game.new
    game.create_board("Computer")
    game.create_board("Player")
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

  def test_it_can_sink_a_ship
    game = Game.new
    game.create_board("Computer")
    computer_board = game.boards.find{|board|board.name == "Computer"}
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    computer_board.place_ship(ship_1)
    assert_equal "Hit!", game.fire_torpedos(computer_board, "c1")
    refute ship_1.sunk

    assert_equal "Hit! Ship_1 has been sunk!", game.fire_torpedos(computer_board, "c2")
    assert ship_1.sunk
  end

  def test_it_returns_true_if_placement_input_is_valid
    game = Game.new
    assert game.valid_placement_input?(["a1", "a2"], 2)
    assert game.valid_placement_input?(["a1", "a2", "a3"], 3)
    refute game.valid_placement_input?(["a"], 2)
    refute game.valid_placement_input?(["a1"], 2)
    refute game.valid_placement_input?(["a1"], 2)
    refute game.valid_placement_input?(["a1", "a"], 2)
    refute game.valid_placement_input?(["a1", "1a"], 2)
    refute game.valid_placement_input?(["a1", "1a"], 2)
    refute game.valid_placement_input?(["a1", "b2"], 3)
    refute game.valid_placement_input?(["a1", "a3", "4a"], 3)
    refute game.valid_placement_input?(["a2", "a", "a1"], 3)
  end

  def test_it_can_render_game_boards
    game = Game.new
    game.create_board("Computer")
    game.create_board("Player")
    ship_1 = Ship.new("ship_1", ["c1", "c2"])
    ship_2 = Ship.new("ship_2", ["d1", "d2", "d3"])

    player_board = game.boards.find{|board|board.name == "Player"}
    player_board.place_ship(ship_1)
    player_board.place_ship(ship_2)
    player_board.get_cell("c1").strike = "H"
    player_board.get_cell("a1").strike = "M"
    player_board.get_cell("d1").strike = "H"
    player_board.get_cell("b4").strike = "M"

    computer_board = game.boards.find{|board|board.name == "Computer"}
    computer_board.place_ship(ship_1)
    computer_board.place_ship(ship_2)
    computer_board.get_cell("c1").strike = "H"
    computer_board.get_cell("a1").strike = "M"
    computer_board.get_cell("d1").strike = "H"
    computer_board.get_cell("b4").strike = "M"

    expected = "       COMPUTER       \n--------------------\n   | 1 | 2 | 3 | 4 |\n A | M |   |   |   |\n B |   |   |   | M |\n C | H |   |   |   |\n D | H |   |   |   |\n\n       PLAYER       \n--------------------\n   | 1 | 2 | 3 | 4 |\n A | M |   |   |   |\n B |   |   |   | M |\n C | H | S |   |   |\n D | H | S | S |   |\n\n"
    assert_output(expected) {game.render_game_boards}
  end

end