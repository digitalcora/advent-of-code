require_relative 'day10'

RSpec.describe Day10 do
  it 'generates the look-and-say sequence starting from the given input' do
    sequence = Day10.new('1').look_and_say

    expect(sequence.take(6)).to eq %w(1 11 21 1211 111221 312211)
  end
end
