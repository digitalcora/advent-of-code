# --- Day 15: Science for Hungry People ---

require 'ostruct'

class Day15
  def initialize(ingredients)
    @ingredients = ingredients.lines.map do |ingredient|
      stats = ingredient.match(/
        (?<capacity>\S+),.*\s
        (?<durability>\S+),.*\s
        (?<flavor>\S+),.*\s
        (?<texture>\S+),.*\s
        (?<calories>\S+)
      /x)

      stats.names.zip(stats.captures.map(&:to_i)).to_h
    end
  end

  def highest_score
    scoring_stats = %w(capacity durability flavor texture)

    (0..100).to_a.repeated_permutation(@ingredients.size).map do |amounts|
      if amounts.reduce(:+) == 100
        scoring_stats.reduce(1) do |total_score, stat|
          stat_score =
            amounts.each_with_index.reduce(0) do |total, (amount, index)|
              total + (amount * @ingredients[index][stat])
            end

          break 0 if stat_score <= 0
          total_score * stat_score
        end
      else
        0
      end
    end.max
  end
end
