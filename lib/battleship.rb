require './lib/game'
require 'pry'

class Battleship

  attr_reader :game

  def initialize
    @game = ""
  end

  def initialize_computer_player
    game = Game.new
    @game = game
    game.create_computer_board
    game.place_computer_ship("small_ship", 2)
    game.place_computer_ship("large_ship", 3)
  end

end