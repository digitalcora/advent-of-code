# --- Day 24: It Hangs in the Balance ---

class Day24
  def initialize(packages)
    @packages = packages
  end

  def ideal_first_group(group_count = 3)
    group_sum = @packages.sum / group_count

    (1..(@packages.size)).lazy.map do |group_size|
      @packages.combination(group_size).select do |packages|
        packages.sum == group_sum
      end
    end.find(&:any?).min_by{ |packages| packages.reduce(:*) }
  end
end
