require_relative 'day17'

RSpec.describe Day17 do
  it 'finds all combinations of containers that can hold the eggnog' do
    expect(test_finder.combinations.size).to eq 4
  end

  it 'finds all combinations that use the minimum number of containers' do
    expect(test_finder.minimal_combinations.size).to eq 3
  end

  def test_finder
    Day17.new(amount: 25, containers: %w(20 15 10 5 5).join("\n"))
  end
end
