require 'day6'

RSpec.describe Day6 do
  it 'determines how many lights are lit after following the instructions' do
    expect(Day6.new('turn on 0,0 through 999,999').lit_count).to eq 1_000_000
    expect(Day6.new('toggle 0,0 through 999,0').lit_count).to eq 1000
    expect(Day6.new([
      'turn on 0,0 through 999,999',
      'toggle 0,0 through 999,0',
      'turn off 499,499 through 500,500'
    ].join("\n")).lit_count).to eq 998_996
  end
end
