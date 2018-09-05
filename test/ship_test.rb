require './test/helper_test'
require './lib/ship'

class ShipTest < Minitest::Test

  def test_it_exists
    ship = Ship.new("ship_1", ["a1", "a2"])
    assert_instance_of Ship, ship
  end

  def test_it_has_a_name
    ship = Ship.new("ship_1", ["a1", "a2"])
    assert_equal "ship_1", ship.name
  end

  def test_it_has_a_location_with_range_of_coordinates
    ship = Ship.new("ship_1", ["a1", "a2"])
    assert_equal ["a1", "a2"], ship.location
  end

  def test_it_starts_out_afloat
    ship = Ship.new("ship_1", ["a1", "a2"])
    refute ship.sunk
  end

end