require 'day24'

RSpec.describe Day24 do
  it 'finds the smallest possible group among 3 groups of equal weight' do
    packages = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11]

    group = Day24.new(packages).ideal_first_group

    expect(group).to eq [9, 11]
  end

  it 'breaks ties for smallest group using the multiplied package weights' do
    group = Day24.new(test_packages).ideal_first_group

    expect(group).to eq [1, 89, 101, 107, 109, 113]
  end

  it 'allows specifying a different number of groups' do
    group = Day24.new(test_packages).ideal_first_group(4)

    expect(group).to eq [61, 107, 109, 113]
  end

  def test_packages
    [
      1, 2, 3, 7, 11, 13, 17, 19, 23, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
      73, 79, 83, 89, 97, 101, 103, 107, 109, 113
    ]
  end
end
