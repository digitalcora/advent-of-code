require_relative 'day15'

RSpec.describe Day15 do
  it 'determines the scores of all possible cookie recipes' do
    expect(Day15.new(test_ingredients).scores.max).to eq 62842880
  end

  it 'determines the scores of recipes with a specified calorie count' do
    expect(Day15.new(test_ingredients).scores(calories: 500).max).to eq 57600000
  end

  def test_ingredients
    [
      'B.scotch: capacity -1, durability -2, flavor 6, texture 3, calories 8',
      'Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3'
    ].join("\n")
  end
end
