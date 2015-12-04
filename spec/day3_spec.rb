require 'day3'

RSpec.describe Day3 do
  it 'determines how many houses will receive at least one present' do
    expect(Day3.new('>').visited_houses).to eq 2
    expect(Day3.new('^>v<').visited_houses).to eq 4
    expect(Day3.new('^v^v^v^v^v').visited_houses).to eq 2
  end
end
