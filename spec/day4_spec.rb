require 'day4'

RSpec.describe Day4 do
  it 'finds the lowest numeric suffix that gives an MD5 starting with 00000' do
    expect(Day4.new('abcdef').mine_advent_coin).to eq 609043
    expect(Day4.new('pqrstuv').mine_advent_coin).to eq 1048970
  end
end
