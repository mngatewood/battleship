require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'

class CellTest < Minitest::Test

  def test_it_exists
    cell = Cell.new("a1")
    assert_instance_of Cell, cell
  end

  def test_it_has_coordinates
    cell = Cell.new("a1")
    assert_equal "a1", cell.coordinates
  end

end
