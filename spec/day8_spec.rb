require 'day8'

RSpec.describe Day8 do
  it 'determines the encoding overhead for a list of strings' do
    expect(Day8.new('""').overhead).to eq 2
    expect(Day8.new('"abc"').overhead).to eq 2
    expect(Day8.new('"aaa\"aaa"').overhead).to eq 3
    expect(Day8.new('"\x5c"').overhead).to eq 5
    expect(Day8.new('"\\\\"').overhead).to eq 3
    expect(Day8.new('"\\\\xa6"').overhead).to eq 3
    expect(Day8.new(['""', '"abc"'].join("\n")).overhead).to eq 4
  end
end
