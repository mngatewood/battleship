require './lib/game'
require 'pry'

def start
  title_screen
  welcome_menu
end

def title_screen
  system "clear" or system "cls"
  puts "---------------------", ""
  puts "Welcome to BATTLESHIP", ""
  puts "---------------------", ""
end

def welcome_menu
  print "Would you like to (p)lay, read the (i)nstructions, or (q)uit? "
  input = gets.chomp.downcase
  if input == "p"
    setup_game
  elsif input == "i"
    display_instructions
  elsif input == "q"
    exit
  else
    puts "", "'#{input}' is not a valid input.  Valid inputs are 'p', 'i', and 'q'."
    welcome_menu
  end
end

def display_instructions
  puts "", "---------------------", ""
  puts "Summary: Battleship is a classic two player game where players try to sink their opponent’s navy ships.", ""
  puts "Object: The basic object of the game of Battleship is to hide your ship fleet somewhere in your ocean and by calling out basic coordinates, find your opponent’s fleet before they find yours.", ""
  puts "Victory Condition: To become the winner of Battleship you must be able to find (sink) all ships in your opponent’s fleet before they sink yours.", ""
  welcome_menu
end

def setup_game
  game = Game.new
  @game = game
  initialize_computer
  initialize_player
end

def initialize_computer
  @game.create_computer_board
  @computer_board = @game.boards.find{|board|board.name == "Computer"}
  @game.place_computer_ship("two_unit_ship", 2)
  @game.place_computer_ship("three_unit_ship", 3)
end

def initialize_player
  @game.create_player_board
  @player_board = @game.boards.find{|board|board.name == "Player"}
  player_placement_instructions
  place_all_player_ships
end

def place_all_player_ships
  if @player_board.ships.length == 0
    place_player_ship(2, "two")
  elsif @player_board.ships.length == 1
    title_screen
    @player_board.render_board
    place_player_ship(3, "three")
  elsif @player_board.ships.length == 2
    play_game
  end
end

def player_placement_instructions
  title_screen
  @player_board.render_board
  puts "I have laid out my ships on the grid."
  puts "You now need to layout your two ships."
  puts "The first is two units long and the second is three units long."
  puts "The grid has A1 at the top left and D4 at the bottom right.", ""
end

def validate_placement_input(input, length)
  array_length = input.length == length
  coord_length = input.map{|coordinate|coordinate.chars.length}.uniq == [2]
  coord_x = input.map{|coordinate|coordinate[1]}.join.count("0-9") == length
  coord_y = input.map{|coordinate|coordinate[0]}.join.count("a-z") == length
  return array_length && coord_length && coord_x && coord_y
end

def place_player_ship(length_number, length_word)
  print "Enter the squares for the #{length_word}-unit ship: "
  input = gets.chomp.downcase.split(" ")
  ship = Ship.new("#{length_word}_unit_ship", input)
  if !validate_placement_input(input, length_number)
    invalid_placement_warning 
  elsif @player_board.validate_location(ship) == true
    @player_board.place_ship(ship)
  else
    puts "", @player_board.validate_location(ship)
    puts "", "Please enter a valid set of coordinates."
  end
  place_all_player_ships
end

def invalid_placement_warning
  puts "", "Please enter a valid set of coordinates."
  puts "For a two-unit ship, an example of a valid input would be a2 a3."
  puts "For a three-unit ship, an example of a valid input would be a2 a3 a4."
  place_all_player_ships
end

def play_game
  title_screen
  @player_board.render_board
end

start
