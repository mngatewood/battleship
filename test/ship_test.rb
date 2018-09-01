require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < Minitest::Test

  def test_it_exists
    ship = Ship.new("ship_1")
    assert_instance_of Ship, ship
  end

  def test_it_has_a_name
    ship = Ship.new("ship_1")
    assert_equal "ship_1", ship.name
  end

end