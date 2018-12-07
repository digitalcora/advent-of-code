require 'day3'

RSpec.describe Day3 do
  it 'determines how many houses will be visited by one Santa' do
    expect(Day3.new('>').visited_houses).to eq 2
    expect(Day3.new('^>v<').visited_houses).to eq 4
    expect(Day3.new('^v^v^v^v^v').visited_houses).to eq 2
  end

  it 'determines how many houses will be visited by two alternating Santas' do
    expect(Day3.new('^v').visited_houses(santas: 2)).to eq 3
    expect(Day3.new('^>v<').visited_houses(santas: 2)).to eq 3
    expect(Day3.new('^v^v^v^v^v').visited_houses(santas: 2)).to eq 11
  end
end
