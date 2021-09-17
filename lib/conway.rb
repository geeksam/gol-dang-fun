module GOL
  extend self

  def fit_cells(width, height, &fitness_test)
    maybe_cell = maybe_cell_from(&fitness_test)
    fit_rows = (0..height).map { |y|
      (0..width).map { |x| maybe_cell.(x,y) }.compact
    }
    fit_rows.inject(Array.new) { |mem, e| mem + e }
  end

  def print_grid(width, height, fitness_test:, glyph:)
    board = fit_cells(width, height, &fitness_test)

    t = ""
    (0..height).each do |y|
      (0..width).each do |x|
        is_fit = board.include?([x,y])
        t << glyph.(is_fit)
      end
      t << "\n"
    end
    t
  end

  def advance_turn(fitness_test)
    next_fitness_test = ->(x,y) {
      maybe_cell = maybe_cell_from(&fitness_test)

      neighbors = [
        [ x-1, y-1 ], [ x, y-1 ], [ x+1, y-1 ],
        [ x-1, y   ],             [ x+1, y   ],
        [ x-1, y+1 ], [ x, y+1 ], [ x+1, y+1 ],
      ]

      living_neighbors = neighbors.map(&maybe_cell).compact

      living_neighbors.length == 3 || (living_neighbors.length == 2 && fitness_test.(x,y))
    }
    next_fitness_test
  end



  private

  def maybe_cell_from(&fitness_test)
    ->(*coords) {
      candidate_cell = coords.flatten
      fitness_test.(*candidate_cell) ? candidate_cell : nil
    }
  end

end
