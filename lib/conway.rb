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
    advance_turn_call_count = 0
    next_fitness_test = ->(x,y) {
      maybe_cell = maybe_cell_from(&fitness_test)
      living_neighbors_and_call_counts = neighbors(x,y).map(&maybe_cell)
      living_neighbors, call_counts = *living_neighbors_and_call_counts.transpose.map(&:compact)

      is_fit_if_2_neighbors, extra_call_count = fitness_test.(x,y)
      is_fit = living_neighbors.length == 3 || (living_neighbors.length == 2 && is_fit_if_2_neighbors)
      call_count = (call_counts.sum || 0) + extra_call_count
      call_count += 1 # for this one
      advance_turn_call_count = call_count
      [ is_fit, call_count ]
    }
    return next_fitness_test, advance_turn_call_count
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
      is_fit, calls = fitness_test.(*candidate_cell)
      cell_or_nil = is_fit ? candidate_cell : nil
      [ cell_or_nil, calls ]
    }
  end

  def flatten_rows(rows)
    rows.inject(Array.new) { |mem, e| mem + e }
  end

end
