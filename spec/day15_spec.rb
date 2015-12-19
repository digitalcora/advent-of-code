require 'day15'

RSpec.describe Day15 do
  it 'determines the score of the highest-scoring cookie that can be made' do
    ingredients = [
      'B.scotch: capacity -1, durability -2, flavor 6, texture 3, calories 8',
      'Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3'
    ].join("\n")

    expect(Day15.new(ingredients).possible_scores.max).to eq 62842880
  end
end
