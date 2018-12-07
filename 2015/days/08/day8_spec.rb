require_relative 'day8'

RSpec.describe Day8 do
  it 'determines the encoding overhead for a list of pre-encoded strings' do
    expect(Day8.new('""').decode_overhead).to eq 2
    expect(Day8.new('"abc"').decode_overhead).to eq 2
    expect(Day8.new('"aaa\"aaa"').decode_overhead).to eq 3
    expect(Day8.new('"\x5c"').decode_overhead).to eq 5
    expect(Day8.new('"\\\\"').decode_overhead).to eq 3
    expect(Day8.new('"\\\\xa6"').decode_overhead).to eq 3
    expect(Day8.new(['""', '"abc"'].join("\n")).decode_overhead).to eq 4
  end

  it 'determines the overhead for encoding a list of not-encoded strings' do
    expect(Day8.new('""').encode_overhead).to eq 4
    expect(Day8.new('"abc"').encode_overhead).to eq 4
    expect(Day8.new('"aaa\"aaa"').encode_overhead).to eq 6
    expect(Day8.new('"\x5c"').encode_overhead).to eq 5
    expect(Day8.new('"\\\\"').encode_overhead).to eq 6
    expect(Day8.new('"\\\\xa6"').encode_overhead).to eq 6
    expect(Day8.new(['""', '"abc"'].join("\n")).encode_overhead).to eq 8
  end
end
