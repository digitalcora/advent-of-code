class Day15
  INGREDIENT_FORMAT = /
    (?<capacity>\S+),.*\s
    (?<durability>\S+),.*\s
    (?<flavor>\S+),.*\s
    (?<texture>\S+),.*\s
    (?<calories>\S+)
  /x

  SCORING_PROPERTIES = %i(capacity durability flavor texture)
  PROPERTIES = SCORING_PROPERTIES + %i(calories)

  def initialize(ingredients)
    @ingredients = ingredients.each_line.map do |ingredient|
      properties = ingredient.match(INGREDIENT_FORMAT)
      properties.names.map(&:to_sym).zip(properties.captures.map(&:to_i)).to_h
    end
  end

  def scores(calories: nil)
    recipes.map do |recipe|
      properties = recipe_properties(recipe)

      if calories.nil? || properties[:calories] == calories
        properties.values_at(*SCORING_PROPERTIES).reduce(:*)
      else
        0
      end
    end
  end

  private

  def recipes
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

  def recipe_properties(ingredient_amounts)
    {}.tap do |properties|
      PROPERTIES.map do |property|
        property_amounts = ingredient_amounts.map.with_index do |amount, index|
          amount * @ingredients[index][property]
        end

        properties[property] = [property_amounts.reduce(:+), 0].max
      end
    end
  end
end
