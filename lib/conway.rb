module GOL
  extend self

  def print_grid(width, height, &fitness_test)
    t = ""
    (0..height).each do |y|
      (0..width).each do |x|
        t << fitness_test.call(x,y).to_s
      end
      t << "\n"
    end
    t
  end

  def advance_turn(fitness_test)
    next_fitness_test = ->(x,y) {
      living_neighbors = [
        fitness_test.(x-1, y-1), fitness_test.(x, y-1), fitness_test.(x+1, y-1),
        fitness_test.(x-1, y-0),                        fitness_test.(x+1, y-0),
        fitness_test.(x-1, y+1), fitness_test.(x, y+1), fitness_test.(x+1, y+1),
      ].map { |e| e ? 1 : 0 }.sum
      living_neighbors == 3 || (living_neighbors == 2 && fitness_test.(x,y))
    }
    next_fitness_test
  end

end
