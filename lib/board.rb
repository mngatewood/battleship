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
    if validate_location(ship) == true
      update_cell(ship)
      @ships << ship
      return true
    else
      return validate_location(ship)
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

  def validate_location(ship)
    if out_of_bounds_cells(ship) != ""
      return "Error.  Cell(s) #{out_of_bounds_cells(ship)} is out of bounds."
    elsif occupied_cells(ship) != ""
      return "Error.  Cell(s) #{occupied_cells(ship)} is occupied."
    elsif get_ship_direction(ship) == "Invalid ship location"
      return "Error.  Ship coordinates must be adjoining and align horizontally or vertically."
    else
      true
    end
  end

  def occupied_cells(ship)
    unoccupied_cells = @cells.find_all{|cell|!cell.occupied}
    unoccupied_cell_coordinates = unoccupied_cells.map{|cell|cell.coordinates}
    return (ship.location - unoccupied_cell_coordinates).join(", ")
  end

  def out_of_bounds_cells(ship)
    in_bound_cells_coordinates = @cells.map{|cell|cell.coordinates}
    return (ship.location - in_bound_cells_coordinates).join(", ")
  end

  def get_all_valid_cells(ship)
    invalid_cells = get_all_invalid_cells(ship)
    all_cells = @cells.map{|cell|cell.coordinates}
    return all_cells - invalid_cells
  end

  def get_all_invalid_cells(ship)
    length = ship.location.length
    direction = get_ship_direction(ship)
    invalid_edges = get_invalid_edges(length, direction)
    occupied_cells = get_occupied_cells
    cells_before_ships = get_invalid_cells_before_all_ships(ship)
    # combine occupied_cells and cell_before_ships
    invalid_cells = invalid_edges + occupied_cells + cells_before_ships
    return invalid_cells.uniq.sort
  end

  def get_invalid_columns(length)
    all_columns = @cells.map {|cell|cell.coordinates[1]}
    unique_columns = all_columns.uniq.sort
    invalid_columns = unique_columns.reverse.take(length - 1)
    all_cells = @cells.map{|cell|cell.coordinates}
    invalid_cells = all_cells.find_all do |cell|
      invalid_columns.any?{|column|column == cell[1]}
    end
    return invalid_cells
  end

  def get_invalid_rows(length)
    all_rows = @cells.map {|cell|cell.coordinates[0]}
    unique_rows = all_rows.uniq.sort
    invalid_rows = unique_rows.reverse.take(length - 1)
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

  def get_occupied_cells
    occupied_cells = @cells.find_all{|cell|cell.occupied}
    return occupied_cells.map{|cell|cell.coordinates}
  end

  def get_invalid_cells_before_all_ships(new_ship)
    invalid_cells = []
    @ships.each do |existing_ship|
      invalid_cells << get_invalid_cells_before_ship(existing_ship, new_ship)
    end
    return invalid_cells.flatten.uniq.sort
  end

  def get_invalid_cells_before_ship(existing_ship, new_ship)
    if get_ship_direction(new_ship) == "h"
      return get_coordinates_left_of_ship(existing_ship, new_ship)
    elsif get_ship_direction(new_ship) == "v"
      return get_coordinates_above_ship(existing_ship, new_ship)
    else
      return "Invalid ship placement"
    end
  end

  def get_ship_direction(ship)
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

  def get_coordinates_above_ship(existing_ship, new_ship)
    location = existing_ship.location
    length = new_ship.location.length
    eliminated_coordinates = []
    while length > 1 && location[0][0] != "a"
      invalid_coordinates = location.map do |coordinate|
        (coordinate[0].ord-1).chr + coordinate[1]
      end
      eliminated_coordinates << invalid_coordinates
      length -= 1
      location = invalid_coordinates
    end
    return eliminated_coordinates.flatten.find_all do |coordinate|
      !existing_ship.location.include?(coordinate)
      end.sort
  end
# combine above and below methods
  def get_coordinates_left_of_ship(existing_ship, new_ship)
    location = existing_ship.location
    length = new_ship.location.length
    eliminated_coordinates = []
    while length > 1 && location[0][1] != "1"
      invalid_coordinates = location.map do |coordinate|
        coordinate[0] + (coordinate[1].to_i - 1).to_s
      end
      eliminated_coordinates << invalid_coordinates
      length -= 1
      location = invalid_coordinates
    end
    return eliminated_coordinates.flatten.find_all do |coordinate|
      !existing_ship.location.include?(coordinate)
      end.sort
  end

  def render_board
    render_board_heading
    rows = @cells.map {|cell|cell.coordinates[0]}.uniq.sort
    columns = @cells.map {|cell|cell.coordinates[1]}.uniq.sort
    rendered_rows = rows.each do |row|
      print " #{row.upcase} |"
      columns.each do |column|
        value = get_cell_value(cells.find do |cell|
          cell.coordinates == row + column
        end)
        print " #{value} |"
      end
      print "\n"
    end
    puts ""
  end

  # puts "       PLAYER                 COMPUTER      "
  # puts "--------------------    --------------------"
  # puts "   | 1 | 2 | 3 | 4 |       | 1 | 2 | 3 | 4 |"
  # puts " A |   |   |   |   |     A |   |   |   |   |"
  # puts " B |   |   |   |   |     B |   |   |   |   |"
  # puts " C |   |   |   |   |     C |   |   |   |   |"
  # puts " D |   |   |   |   |     D |   |   |   |   |"

  def render_board_heading
    puts "       #{@name.upcase}       "
    puts "--------------------"
    puts "   | 1 | 2 | 3 | 4 |"
  end

  def get_cell_value(cell)
    if @name == "Player"
      return player_cell_value(cell)
    elsif @name == "Computer"
      return computer_cell_value(cell)
    end
  end

  def player_cell_value(cell)
    if !cell.strike && !cell.occupied
      return " "
    elsif !cell.strike
      return "S"
    else
      return cell.strike
    end
  end

  def computer_cell_value(cell)
    if !cell.strike
      return " "
    else
      return cell.strike
    end
  end

end