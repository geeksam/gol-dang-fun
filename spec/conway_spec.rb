require_relative 'spec_helper'
require "approvals/rspec"

RSpec.describe "the game of life (don't talk to me about life)" do

  specify "a single cell dies" do
    verify_board { |x,y| x == 1 && y == 2 }
  end



  def verify_board(&board)
    verify do
      frames = []
      frames << GOL.print_grid(5, 4) { |x,y| board.(x,y) ? "x" : "." }
      board = GOL.advance_turn(board)
      frames << GOL.print_grid(5, 4) { |x,y| board.(x,y) ? "x" : "." }
      frames.join("\n--NEXT TURN--\n\n")
    end
  end

end
