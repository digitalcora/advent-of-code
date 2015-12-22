# --- Day 17: No Such Thing as Too Much ---

class Day17
  def initialize(amount:, containers:)
    @amount = amount
    @containers = containers.lines.map(&:to_i)
  end

  def combinations
    (1..@containers.size).flat_map do |containers_count|
      @containers.combination(containers_count).select do |combination|
        combination.reduce(:+) == @amount
      end
    end
  end
end
