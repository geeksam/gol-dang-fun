module GOL
  extend self

  def fit_cells(width, height, &fitness_test)
    maybe_cell = maybe_cell_from(&fitness_test)
    fit_rows = (0..height).map { |y|
      (0..width).map { |x| maybe_cell.(x,y) }.compact
    }
    flatten_rows(fit_rows)
  end

  def print_grid(width, height, fitness_test:, glyph:)
    board = fit_cells(width, height, &fitness_test)

    (0..height).map { |y|
      (0..width).map { |x|
        is_fit = board.include?([x,y])
        glyph.(is_fit)
      }.join
    }.join("\n") + "\n" # the final newline is just to match the already-approved output
  end

  def advance_turn(fitness_test)
    next_fitness_test = ->(x,y) {
      maybe_cell = maybe_cell_from(&fitness_test)
      living_neighbors = neighbors(x,y).map(&maybe_cell).compact
      living_neighbors.length == 3 || (living_neighbors.length == 2 && fitness_test.(x,y))
    }
    next_fitness_test
  end



  private

  def neighbors(x,y)
    [
      [ x-1, y-1 ], [ x, y-1 ], [ x+1, y-1 ],
      [ x-1, y   ],             [ x+1, y   ],
      [ x-1, y+1 ], [ x, y+1 ], [ x+1, y+1 ],
    ]
  end

  def maybe_cell_from(&fitness_test)
    ->(*coords) {
      candidate_cell = coords.flatten
      fitness_test.(*candidate_cell) ? candidate_cell : nil
    }
  end

  def flatten_rows(rows)
    rows.inject(Array.new) { |mem, e| mem + e }
  end

end
