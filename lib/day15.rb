# --- Day 15: Science for Hungry People ---

require 'ostruct'

class Day15
  def initialize(ingredients)
    @ingredients = ingredients.lines.map do |ingredient|
      properties = ingredient.match(/
        (?<capacity>\S+),.*\s
        (?<durability>\S+),.*\s
        (?<flavor>\S+),.*\s
        (?<texture>\S+),.*\s
        (?<calories>\S+)
      /x)

      properties.names.zip(properties.captures.map(&:to_i)).to_h
    end
  end

  def possible_scores
    scoring_properties = %w(capacity durability flavor texture)

    possible_recipes.map do |recipe|
      property_scores = scoring_properties.map do |property|
        ingredient_scores = recipe.map.with_index do |ingredient_amount, index|
          ingredient_amount * @ingredients[index][property]
        end

        [ingredient_scores.reduce(:+), 0].max
      end

      property_scores.reduce(:*)
    end
  end

  private

  def possible_recipes
    amounts = [100] + ([0] * (@ingredients.size - 1))

    Enumerator.new do |yielder|
      loop do
        yielder << amounts.dup
        raise StopIteration if amounts.last == 100

        split_index = amounts.find_index(&:nonzero?)
        amounts[split_index] -= 1
        amounts[split_index + 1] += 1
        balance = amounts[split_index]
        amounts[split_index] = 0
        amounts[0] = balance
      end
    end
  end
end
