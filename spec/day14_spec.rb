require 'day14'

RSpec.describe Day14 do
  it 'determines how far the reindeer have raced after a given time' do
    reindeer = [
      'Comet can fly 14 km/s for 10 seconds, ' +
        'but then must rest for 127 seconds.',
      'Dancer can fly 16 km/s for 11 seconds, ' +
        'but then must rest for 162 seconds.'
    ].join("\n")

    distances = Day14.new(reindeer).distances_at_time(1000)

    expect(distances.max).to eq 1120
  end
end
