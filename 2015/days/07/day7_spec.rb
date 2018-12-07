require_relative 'day7'

RSpec.describe Day7 do
  it 'assembles circuits and determines the resulting wire signals' do
    instructions = [
      '123 -> x',
      '456 -> y',
      'x AND y -> d',
      'x OR y -> e',
      'x LSHIFT 2 -> f',
      'y RSHIFT 2 -> g',
      'NOT x -> h',
      'NOT y -> i'
    ].join("\n")

    expect(Day7.new(instructions).outputs).to eq({
      d: 72,
      e: 507,
      f: 492,
      g: 114,
      h: 65412,
      i: 65079,
      x: 123,
      y: 456
    })
  end
end
