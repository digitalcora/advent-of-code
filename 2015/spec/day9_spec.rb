require 'day9'

RSpec.describe Day9 do
  it 'finds the distances of routes that visit each location exactly once' do
    edges = [
      'London to Dublin = 464',
      'London to Belfast = 518',
      'Dublin to Belfast = 141'
    ].join("\n")

    distances = Day9.new(edges).distances

    expect(distances.min).to eq 605
    expect(distances.max).to eq 982
  end
end
