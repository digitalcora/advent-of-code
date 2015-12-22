require 'day17'

RSpec.describe Day17 do
  it 'determines how many combinations of containers can hold the eggnog' do
    day17 = Day17.new(amount: 25, containers: %w(20 15 10 5 5).join("\n"))

    expect(day17.combinations.size).to eq 4
  end
end
