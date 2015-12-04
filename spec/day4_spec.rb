require 'day4'

RSpec.describe Day4 do
  it 'mines Advent Coins with selectable difficulty' do
    expect(Day4.new('abcdef').mine_coin(difficulty: 5)).to eq 609043
    expect(Day4.new('pqrstuv').mine_coin(difficulty: 5)).to eq 1048970
    expect(Day4.new('ckczppom').mine_coin(difficulty: 6)).to eq 3938038
  end
end
