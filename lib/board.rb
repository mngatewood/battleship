require './lib/cell'
require './lib/ship'
require 'pry'

class Board

  attr_reader :name,
              :cells,
              :ships

  def initialize(name)
    @name = name
    @cells = []
    @ships = []
  end

  def add_cell(cell)
    @cells << cell
  end

  def create_grid
    letters = ["a", "b", "c", "d"]
    numbers = ["1", "2", "3", "4"]
    letters.each do |letter|
      numbers.each do |number|
        coordinates = letter + number
        cell = Cell.new(coordinates)
        add_cell(cell)
      end
    end
  end

  def place_ship(ship)
    if valid_location?(ship)
      update_cell(ship)
      @ships << ship
      return true
    else
      return false
    end
  end

  def update_cell(ship)
    ship.location.each do |coordinate|
      get_cell(coordinate).occupied = true
    end
  end

  def get_cell(coordinates)
    @cells.find{|cell|cell.coordinates == coordinates}
  end

  def valid_location?(ship)
    cell_coordinates = @cells.map{|cell|cell.coordinates}
    (ship.location - cell_coordinates).empty?
  end

  def eliminate_all_invalid_cells()
    
  end

  def get_invalid_columns(length)
    all_columns = @cells.map {|cell|cell.coordinates[1]}
    unique_columns = all_columns.uniq.sort
    invalid_columns = unique_columns.reverse.drop(length - 1)
    all_cells = @cells.map{|cell|cell.coordinates}
    invalid_cells = all_cells.find_all do |cell|
      invalid_columns.any?{|column|column == cell[1]}
    end
    return invalid_cells
  end

  def get_invalid_rows(length)
    all_rows = @cells.map {|cell|cell.coordinates[0]}
    unique_rows = all_rows.uniq.sort
    invalid_rows = unique_rows.reverse.drop(length - 1)
    all_cells = @cells.map{|cell|cell.coordinates}
    invalid_cells = all_cells.find_all do |cell|
      invalid_rows.any?{|row|row == cell[0]}
    end
    return invalid_cells
  end

  def get_invalid_edges(length, direction)
    if direction == "h" && length > 1
      get_invalid_columns(length)
    elsif direction == "v" && length > 1
      get_invalid_rows(length)
    else
      "Invalid parameters"
    end
  end

  def eliminate_occupied_cells
    @cells.find_all{|cell|!cell.occupied}
  end

  def get_invalid_cells_before_all_ships(length_of_new_ship)
    invalid_cells = []
    @ships.each do |ship|
      invalid_cells << get_invalid_cells_before_ship(ship, length_of_new_ship)
    end
    return invalid_cells.flatten.uniq.sort
  end

  def eliminate_cells_before_ship(ship, length_of_new_ship)
    invalid_cells = get_invalid_cells_before_ship(ship, length_of_new_ship)
    if invalid_cells == "Invalid ship placement"
      return "Invalid ship placement"
    else
      @cells.find_all do |cell|
        invalid_cells.none? do |coordinate|
          coordinate == cell.coordinates
        end
      end
    end
  end

  def get_invalid_cells_before_ship(ship, length)
    if determine_ship_direction(ship) == "h"
      return get_coordinates_above_ship(ship.location, length)
    elsif determine_ship_direction(ship) == "v"
      return get_coordinates_left_of_ship(ship.location, length)
    else
      return "Invalid ship placement"
    end
  end

  def determine_ship_direction(ship)
    rows = ship.location.map{|coordinate|coordinate[0]}
    columns = ship.location.map{|coordinate|coordinate[1]}
    if array_identical?(columns) && array_incremental?(rows)
      return "v"
    elsif array_identical?(rows) && array_incremental?(columns)
      return "h"
    else
      return "Invalid ship location"
    end
  end

  def array_incremental?(array)
    array.each_cons(2).all? {|x,y|y.ord == x.ord + 1}
  end

  def array_identical?(array)
    array.all?{|element|element == array[0]}
  end

  def get_coordinates_above_ship(location, length)
    eliminated_coordinates = []
    while length > 0 && location[0][0] != "a"
      invalid_coordinates = location.map do |coordinate|
        (coordinate[0].ord-1).chr + coordinate[1]
      end
      eliminated_coordinates << invalid_coordinates
      length -= 1
      location = invalid_coordinates
    end
    return eliminated_coordinates.flatten.sort
  end

  def get_coordinates_left_of_ship(location, length)
    eliminated_coordinates = []
    while length > 0 && location[0][1] != "1"
      invalid_coordinates = location.map do |coordinate|
        coordinate[0] + (coordinate[1].to_i - 1).to_s
      end
      eliminated_coordinates << invalid_coordinates
      length -= 1
      location = invalid_coordinates
    end
    return eliminated_coordinates.flatten.sort
  end

end