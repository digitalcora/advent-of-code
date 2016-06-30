require 'day20'

RSpec.describe Day20, :focus do
  it 'finds the first house to get at least a given number of presents' do
    expect(Day20.new(target_presents: 150).first_house_number).to eq 8
  end

  it 'accepts a multiplier for the number of presents delivered' do
    finder = Day20.new(target_presents: 240, present_multiplier: 20)

    expect(finder.first_house_number).to eq 6
  end

  it 'accepts a maximum number of houses that each elf will visit' do
    finder = Day20.new(target_presents: 390, house_limit: 5)

    expect(finder.first_house_number).to eq 20
  end
end
