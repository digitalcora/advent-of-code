require 'day4'

RSpec.describe Day4 do
  it 'mines Advent Coins' do
    expect(Day4.new('abcdef').mine_coin).to eq 609043
    expect(Day4.new('pqrstuv').mine_coin).to eq 1048970
  end

  it 'allows specifying a difficulty' do
    expect(Day4.new('abcdef').mine_coin(difficulty: 4)).to eq 31556
  end
end
