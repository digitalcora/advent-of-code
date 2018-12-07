require_relative 'day2'

RSpec.describe Day2 do
  it 'tells the elves how many square feet of wrapping paper they need' do
    expect(Day2.new('2x3x4').paper_needed).to eq 58
    expect(Day2.new('1x1x10').paper_needed).to eq 43
    expect(Day2.new("2x3x4\n1x1x10").paper_needed).to eq 101
  end

  it 'tells the elves how many feet of ribbon they need' do
    expect(Day2.new('2x3x4').ribbon_needed).to eq 34
    expect(Day2.new('1x1x10').ribbon_needed).to eq 14
    expect(Day2.new("2x3x4\n1x1x10").ribbon_needed).to eq 48
  end
end
