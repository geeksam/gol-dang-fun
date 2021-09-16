require_relative 'spec_helper'
require "approvals/rspec"

RSpec.describe "the game of life (don't talk to me about life)" do
  GRID_WIDTH  = 5
  GRID_HEIGHT = 4

  specify "a single cell dies" do
    verify_fitness_test { |x,y| x == 1 && y == 2 }
  end

  specify "a square survives" do
    verify_fitness_test { |x,y| (1..2).cover?(x) && (1..2).cover?(y) }
  end

  specify "a square blinker cycles" do
    verify_fitness_test(iterations: 4) { |x,y|
      (
        ( (0..1).cover?(x) && (0..1).cover?(y) ) ||
        ( (2..3).cover?(x) && (2..3).cover?(y) )
      )
    }
  end

  specify "a regular old blinker does whatever it does" do
    verify_fitness_test(iterations: 4) { |x,y| (1..3).cover?(x) && y == 2 }
  end



  def verify_fitness_test(iterations: 2, &fitness_test)
    verify do
      iterate_fitness_test(iterations, &fitness_test)
    end
  end

  def iterate_fitness_test(iterations=2, &fitness_test)
    frames = []
    glyph = ->(fit) { fit ? "x" : "." }
    frames << GOL.print_grid(GRID_WIDTH, GRID_HEIGHT, fitness_test: fitness_test, glyph: glyph)
    # start at 2 because we had to seed the first one?
    (2..iterations).each do
      fitness_test = GOL.advance_turn(fitness_test)
      frames << GOL.print_grid(GRID_WIDTH, GRID_HEIGHT, fitness_test: fitness_test, glyph: glyph)
    end
    frames.join("\n--NEXT TURN--\n\n")
  end

end
