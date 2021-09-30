require_relative 'spec_helper'
require "approvals/rspec"
require "awesome_print"

RSpec.describe "the game of life (don't talk to me about life)" do
  GRID_WIDTH  = 5
  GRID_HEIGHT = 4

  specify "a single cell dies" do
    pending "print_grid uses fit_cells, and fit_cells needs to account for the new shape of data returned from fitness tests"
    verify_fitness_test { |x,y| [ x == 1 && y == 2, 1 ] }
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

=begin
  specify "a really weird board" do
    gosper_glider_gun = <<~EOF
      .....................................
      .........................x...........
      .......................x.x...........
      .............xx......xx...........xx.
      ............x...x....xx...........xx.
      .xx........x.....x...xx..............
      .xx........x...x.xx....x.x...........
      ...........x.....x.......x...........
      ............x...x....................
      .............xx......................
      .....................................
    EOF

    living_cell_rows = gosper_glider_gun.lines.map(&:strip).map.with_index { |line, y|
      line.chars.map.with_index { |glyph, x| glyph == "x" ? [x,y] : nil }.compact
    }
    initial_living_cells = living_cell_rows.inject(Array.new) { |mem, e| mem + e }.sort

    calls = 0
    round_1_fitness_test = ->(x,y) {
      calls += 1
      initial_living_cells.include?([x,y])
    }

    round_2_fitness_test, calls_after_round_2 = GOL.advance_turn(round_1_fitness_test)
    round_3_fitness_test, calls_after_round_2 = GOL.advance_turn(round_1_fitness_test)








    # ROUND 1
    xs = initial_living_cells.map(&:first) ; bounding_xs = (xs.min)..(xs.max)
    ys = initial_living_cells.map(&:last)  ; bounding_ys = (ys.min)..(ys.max)

    # generate our initial set of living cells
    living_cell_rows = bounding_ys.map { |y|
      bounding_xs.map { |x|
        is_fit = fitness_test.call(x,y)
        is_fit ? [x,y] : nil
      }
    }
    living_cells = living_cell_rows.inject(Array.new) { |mem, e| mem + e }.compact.sort

    expect( living_cells ).to eq( initial_living_cells )
p calls


    # ROUND 2
    xs = living_cells.map(&:first) ; bounding_xs = (xs.min)..(xs.max)
    ys = living_cells.map(&:last)  ; bounding_ys = (ys.min)..(ys.max)

    # generate our initial set of living cells
    living_cell_rows = bounding_ys.map { |y|
      bounding_xs.map { |x|
        is_fit = fitness_test.call(x,y)
        is_fit ? [x,y] : nil
      }
    }
    living_cells = living_cell_rows.inject(Array.new) { |mem, e| mem + e }.compact.sort


p calls
    fail "what do here?"
  end
=end

  specify "complexity of a square blinker is O(scary)" do
=begin

  So.  We want to count the number of times we call a fitness function, and
  verify that that count increases exponentially after each turn.

  In order to do this, we need to have the GOL.advance_turn method return the
  total number of calls along with the next fitness test.

  PAY NO ATTENTION to the .print_grid and .fit_cells behind the curtain!

=end
    fitness_test_0 = ->(x,y) {
      is_fit = (
        ( (0..1).cover?(x) && (0..1).cover?(y) ) ||
        ( (2..3).cover?(x) && (2..3).cover?(y) )
      )
      [ is_fit, 1 ]
    }

    fitness_test_1, calls_1 = GOL.advance_turn(fitness_test_0)
    expect( calls_1 ).to eq( -1 )

    _, calls_2 = GOL.advance_turn(fitness_test_1)
    expect( calls_2 ).to eq( -1 )
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
      fitness_test, _ = GOL.advance_turn(fitness_test)
      frames << GOL.print_grid(GRID_WIDTH, GRID_HEIGHT, fitness_test: fitness_test, glyph: glyph)
    end
    frames.join("\n--NEXT TURN--\n\n")
  end

end
