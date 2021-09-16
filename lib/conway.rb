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
    ->(*) { false }
  end

end
