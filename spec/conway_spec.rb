require_relative 'spec_helper'
require "approvals/rspec"

RSpec.describe "the game of life (don't talk to me about life)" do

  specify "a single cell dies" do
    verify_board { |x,y| x == 1 && y == 2 }
  end

  specify "a square survives" do
    verify_board { |x,y| (1..2).cover?(x) && (1..2).cover?(y) }
  end

  specify "a square blinker cycles" do
    verify_board(iterations: 4) { |x,y|
      (
        ( (0..1).cover?(x) && (0..1).cover?(y) ) ||
        ( (2..3).cover?(x) && (2..3).cover?(y) )
      )
    }
  end



  def verify_board(iterations: 2, &board)
    verify do
      frames = []
      frames << GOL.print_grid(5, 4) { |x,y| board.(x,y) ? "x" : "." }
      # start at 2 because we had to seed the first one?
      (2..iterations).each do
        board = GOL.advance_turn(board)
        frames << GOL.print_grid(5, 4) { |x,y| board.(x,y) ? "x" : "." }
      end
      frames.join("\n--NEXT TURN--\n\n")
    end
  end

end
