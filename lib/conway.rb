module GOL
  extend self

  def print_grid(width, height, &board)
    t = ""
    (0..height).each do |y|
      (0..width).each do |x|
        t << board.call(x,y).to_s
      end
      t << "\n"
    end
    t
  end

  def advance_turn(board)
    next_board = ->(x,y) {
      living_neighbors = [
        board.(x-1, y-1), board.(x, y-1), board.(x+1, y-1),
        board.(x-1, y-0),                 board.(x+1, y-0),
        board.(x-1, y+1), board.(x, y+1), board.(x+1, y+1),
      ].map { |e| e ? 1 : 0 }.sum
      living_neighbors == 3 || (living_neighbors == 2 && board.(x,y))
    }
    next_board
  end

end
