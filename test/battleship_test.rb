require 'minitest/autorun'
require 'minitest/pride'
require './lib/battleship'

class BattleshipTest < Minitest::Test

  def test_it_exists
    battleship = Battleship.new
    assert_instance_of Battleship, battleship
  end

  def test_it_prints_game_start_prompt
    battleship = Battleship.new
    output = "Welcome to BATTLESHIP \n \n Would you like to (p)lay, read the (i)nstructions, or (q)uit?"
    assert_output( stdout = output ) { battleship.print_game_start_prompt}
  end

end