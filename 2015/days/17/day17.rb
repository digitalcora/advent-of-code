class Day17
  def initialize(amount:, containers:)
    @amount = amount
    @containers = containers.lines.map(&:to_i)
  end

  def combinations
    @_combinations ||= (1..@containers.size).flat_map do |containers_count|
      @containers.combination(containers_count).select do |combination|
        combination.reduce(:+) == @amount
      end
    end
  end

  def minimal_combinations
    smallest_size = combinations.min_by(&:size).size
    combinations.select{ |combination| combination.size == smallest_size }
  end
end
