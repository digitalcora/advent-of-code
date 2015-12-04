require_relative '../lib/day1'

RSpec.describe Day1 do
  it 'directs Santa to the correct floor of the apartment building' do
    expect(Day1.new('(())').floor).to eq 0
    expect(Day1.new('()()').floor).to eq 0
    expect(Day1.new('(((').floor).to eq 3
    expect(Day1.new('(()(()(').floor).to eq 3
    expect(Day1.new('))(((((').floor).to eq 3
    expect(Day1.new('())').floor).to eq(-1)
    expect(Day1.new('))(').floor).to eq(-1)
    expect(Day1.new(')))').floor).to eq(-3)
    expect(Day1.new(')())())').floor).to eq(-3)
  end
end
