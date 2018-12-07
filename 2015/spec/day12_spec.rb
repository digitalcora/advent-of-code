require 'day12'

RSpec.describe Day12 do
  it 'adds up all the numbers in a JSON document' do
    expect(Day12.new('[1,2,3]').sum).to eq 6
    expect(Day12.new('{"a":2,"b":4}').sum).to eq 6
    expect(Day12.new('[[[3]]]').sum).to eq 3
    expect(Day12.new('{"a":{"b":4},"c":-1}').sum).to eq 3
    expect(Day12.new('{"a":[-1,1]}').sum).to eq 0
    expect(Day12.new('[-1,{"a":1}]').sum).to eq 0
    expect(Day12.new('[]').sum).to eq 0
    expect(Day12.new('{}').sum).to eq 0
  end

  it 'adds all numbers except within any objects that contain a "red" value' do
    expect(Day12.new('[1,2,3]').sum(ignore_red: true)).to eq 6
    expect(Day12.new('[1,{"c":"red","b":2},3]').sum(ignore_red: true)).to eq 4
    expect(Day12.new('{"d":"red","e":[2],"f":5}').sum(ignore_red: true)).to eq 0
    expect(Day12.new('[1,"red",5]').sum(ignore_red: true)).to eq 6
  end
end
