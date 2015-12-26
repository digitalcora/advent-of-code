# --- Day 18: Like a GIF For Your Yard ---

class Day18
  def initialize(grid)
    @grid = grid.each_line.map do |line|
      line.chomp.each_char.map do |char|
        char == '#'
      end
    end
  end

  def live_cells_at(generation)
    grid = @grid

    generation.times do
      grid = grid.map.with_index do |row, y|
        row.map.with_index do |cell, x|
          live_neighbors = neighbor_values(grid, x, y).count(true)

          if cell
            live_neighbors.between?(2, 3)
          else
            live_neighbors == 3
          end
        end
      end
    end

    grid.flatten.count(true)
  end

  private

  def neighbor_values(grid, x, y)
    [
      (grid[y-1][x-1] if y > 0 && x > 0),
      (grid[y-1][x] if y > 0),
      (grid[y-1][x+1] if y > 0 && x < grid.first.size - 1),
      (grid[y][x-1] if x > 0),
      (grid[y][x+1] if x < grid.first.size - 1),
      (grid[y+1][x-1] if y < grid.size - 1 && x > 0),
      (grid[y+1][x] if y < grid.size - 1),
      (grid[y+1][x+1] if y < grid.size - 1 && x < grid.first.size - 1)
    ]
  end
end
