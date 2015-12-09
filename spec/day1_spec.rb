require 'day1'

RSpec.describe Day1 do
  it 'directs Santa to the correct floor of the apartment building' do
    expect(Day1.new('(())').final_floor).to eq 0
    expect(Day1.new('()()').final_floor).to eq 0
    expect(Day1.new('(((').final_floor).to eq 3
    expect(Day1.new('(()(()(').final_floor).to eq 3
    expect(Day1.new('))(((((').final_floor).to eq 3
    expect(Day1.new('())').final_floor).to eq(-1)
    expect(Day1.new('))(').final_floor).to eq(-1)
    expect(Day1.new(')))').final_floor).to eq(-3)
    expect(Day1.new(')())())').final_floor).to eq(-3)
  end

  it 'gives the position of the first direction that enters the basement' do
    expect(Day1.new(')').basement_position).to eq 1
    expect(Day1.new('()())').basement_position).to eq 5
    expect(Day1.new('(').basement_position).to eq nil
  end
end
