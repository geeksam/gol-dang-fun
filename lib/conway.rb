module GOL
  extend self

  def print_grid(width, height, fitness_test:, glyph:)
    t = ""
    (0..height).each do |y|
      (0..width).each do |x|
        fit = fitness_test.(x,y)
        t << glyph.(fit)
      end
      t << "\n"
    end
    t
  end

  def advance_turn(fitness_test)
    next_fitness_test = ->(x,y) {
      maybe_cell = ->(x,y) { fitness_test.(x,y) ? [x,y] : nil }
      living_neighbors = [
        maybe_cell.(x-1, y-1), maybe_cell.(x, y-1), maybe_cell.(x+1, y-1),
        maybe_cell.(x-1, y-0),                      maybe_cell.(x+1, y-0),
        maybe_cell.(x-1, y+1), maybe_cell.(x, y+1), maybe_cell.(x+1, y+1),
      ].compact
      living_neighbors.length == 3 || (living_neighbors.length == 2 && fitness_test.(x,y))
    }
    next_fitness_test
  end

end
