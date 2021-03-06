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

def render_player_board_only
  title_screen
  @player_board.render_board
end

def render_game_boards
  title_screen
  @computer_board.render_board
  @player_board.render_board
end

def interrupt
  print "Press enter to continue. "
  while input = gets.chomp
    if input == ""
      break
    end
  end
end

def welcome_menu
  print "Would you like to (p)lay, read the (i)nstructions, or (q)uit? "
  input = gets.chomp.downcase
  if input == "p" || input == "play"
    setup_game
  elsif input == "i" || input == "instructions"
    display_instructions
  elsif input == "q" || input == "quit"
    exit
  else
    display_welcome_menu_help(input)
  end
end

def display_instructions
  title_screen
  puts "Summary:  Battleship is a classic two player game where players try to
          sink their opponent’s navy ships.", ""
  puts "Object:   The basic object of the game of Battleship is to hide your 
          ship fleet somewhere in your ocean and by calling out basic 
          coordinates, find your opponent’s fleet before they find yours.", ""
  puts "Victory:  To become the winner of Battleship you must be able 
          to find (sink) all ships in your opponent’s fleet before they sink 
          yours.", ""
  welcome_menu
end

def display_welcome_menu_help(input)
  puts "", "'#{input}' is not a valid input."
  puts "Valid inputs are 'p', 'i', 'q', 'play', 'instructions', and 'quit'."
  welcome_menu
end

def setup_game
  game = Game.new
  @game = game
  initialize_computer
  initialize_player
end

def initialize_computer
  @game.create_board("Computer")
  @computer_board = @game.boards.find{|board|board.name == "Computer"}
  @computer_board.place_computer_ship("two_unit_ship", 2)
  @computer_board.place_computer_ship("three_unit_ship", 3)
end

def initialize_player
  @game.create_board("Player")
  @player_board = @game.boards.find{|board|board.name == "Player"}
  player_placement_instructions
  interrupt
  place_all_player_ships
end

def player_placement_instructions
  render_player_board_only
  puts "I have laid out my ships on the grid."
  puts "You now need to layout your two ships."
  puts "The first is two units long and the second is three units long."
  puts "The grid has A1 at the top left and D4 at the bottom right.", ""
end

def place_all_player_ships
  render_player_board_only
  if @player_board.ships.length == 0
    place_player_ship(2, "two")
  elsif @player_board.ships.length == 1
    place_player_ship(3, "three")
  elsif @player_board.ships.length == 2
    player_turn
  end  
end  

def place_player_ship(length_number, length_word)
  print "Enter the squares for the #{length_word}-unit ship: "
  input = gets.chomp.downcase.split(" ")
  ship = Ship.new("#{length_word}_unit_ship", input)
  if !@game.valid_placement_input?(input, length_number)
    invalid_placement_warning 
  elsif @player_board.validate_location(ship) == true
    @player_board.place_ship(ship)
    puts "Your ship has been successfully placed.", ""
  else
    puts "", @player_board.validate_location(ship)
    puts "Please enter a valid set of coordinates.", ""
  end
  interrupt
  place_all_player_ships
end

def invalid_placement_warning
  render_player_board_only
  puts "", "Please enter a valid set of coordinates."
  puts "For a two-unit ship, an example of a valid input would be a2 a3."
  puts "For a three-unit ship, an example of a valid input would be a2 a3 a4."
  puts ""
end

def player_turn
  render_game_boards
  print "Torpedos ready! Enter a coordinate to fire. "
  input = gets.chomp.downcase
  shot_result = @game.fire_torpedos(@computer_board, input)
  if shot_result == "Invalid coordinate"
    display_fire_help(shot_result)
  else
    player_shot(shot_result)
  end
end

def display_fire_help(shot_result)
  puts shot_result, "Please enter a new coordinate."
  interrupt
  player_turn
end

def player_shot(shot_result)
  render_game_boards
  puts shot_result, ""
  @computer_board.victory? && victory_end_game
  puts "Your turn is complete.", ""
  interrupt
  computer_turn
end

def victory_end_game
  puts "You have sunk all of the computer's ships!"
  puts "You are victorious!"
  interrupt
  start
end

def defeat_end_game
  puts "The computer has sunk all of your ships!"
  puts "You have lost the battle"
  interrupt
  start
end

def computer_turn
  render_game_boards
  target = computer_target
  shot_result = @game.fire_torpedos(@player_board, target)
  render_game_boards
  puts "Computer fired at square #{target}.", "", shot_result, ""
  @player_board.victory? && defeat_end_game
  puts "Computer turn is complete.", ""
  interrupt
  player_turn
end

def computer_target
  all_cell_coordinates = @player_board.cells.map{|cell|cell.coordinates}
  fired_cells = @player_board.cells.find_all{|cell|cell.strike}
  fired_cells_coordinates = fired_cells.map{|cell|cell.coordinates}
  valid_target_coordinates = all_cell_coordinates - fired_cells_coordinates
  target_cell_coordinates = valid_target_coordinates.sample
  return target_cell_coordinates
end

start
