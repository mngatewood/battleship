require 'minitest/autorun'
require 'minitest/pride'
require './lib/battleship'

class BattleshipTest < Minitest::Test

  def test_it_exists
    battleship = Battleship.new
    assert_instance_of Battleship, battleship
  end

  def test_it_starts_with_no_games
    battleship = Battleship.new
    assert_equal "", battleship.game
  end

  def test_it_can_initialize_a_computer_board
    battleship = Battleship.new
    battleship.initialize_computer
    assert_equal "Computer", battleship.game.boards[0].name
    assert_equal 16, battleship.game.boards[0].cells.length
    assert_equal 2, battleship.game.boards[0].ships.length     
  end

  def test_it_can_initialize_a_player_board
    battleship = Battleship.new
    battleship.initialize_player
    assert_equal "Player", battleship.game.boards[0].name
    assert_equal 16, battleship.game.boards[0].cells.length
    assert_equal 0, battleship.game.boards[0].ships.length     
  end

end