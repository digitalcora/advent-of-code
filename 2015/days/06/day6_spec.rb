require_relative 'day6'

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

  it 'determines the total brightness after following the new instructions' do
    expect(Day6.new('turn on 0,0 through 0,0').brightness).to eq 1
    expect(Day6.new('toggle 0,0 through 999,999').brightness).to eq 2_000_000
    expect(Day6.new([
      'turn on 0,0 through 999,999',
      'toggle 0,0 through 999,0',
      'turn off 499,499 through 500,500',
      'turn off 500,500 through 500,500'
    ].join("\n")).brightness).to eq 1_001_996
  end
end
