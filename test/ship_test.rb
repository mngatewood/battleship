require './test/helper_test'
require './lib/ship'

class ShipTest < Minitest::Test

  def test_it_exists
    ship = Ship.new("two_unit_ship", ["a1", "a2"])
    assert_instance_of Ship, ship
  end

  def test_it_has_a_name
    ship = Ship.new("two_unit_ship", ["a1", "a2"])
    assert_equal "two_unit_ship", ship.name
  end

  def test_it_has_a_location_with_range_of_coordinates
    ship_1 = Ship.new("two_unit_ship", ["a1", "a2"])
    ship_2 = Ship.new("three_unit_ship", ["a1", "a2", "a3"])
    assert_equal ["a1", "a2"], ship_1.location
    assert_equal ["a1", "a2", "a3"], ship_2.location
  end

  def test_it_starts_out_afloat
    ship = Ship.new("two_unit_ship", ["a1", "a2"])
    refute ship.sunk
  end

end