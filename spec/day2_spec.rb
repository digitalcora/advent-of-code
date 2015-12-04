require 'day2'

RSpec.describe Day2 do
  it 'tells the elves how many square feet of wrapping paper they need' do
    expect(Day2.new('2x3x4').paper_needed).to eq 58
    expect(Day2.new('1x1x10').paper_needed).to eq 43
    expect(Day2.new("2x3x4\n1x1x10").paper_needed).to eq 101
  end
end
