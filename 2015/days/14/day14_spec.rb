require_relative 'day14'

RSpec.describe Day14 do
  it 'determines how far the reindeer have raced and what their scores are' do
    reindeer = [
      'Comet can fly 14 km/s for 10 seconds, ' +
        'but then must rest for 127 seconds.',
      'Dancer can fly 16 km/s for 11 seconds, ' +
        'but then must rest for 162 seconds.'
    ].join("\n")

    racers = Day14.new(reindeer).racers_at_time(1000)

    expect(racers.map(&:name)).to eq %w(Comet Dancer)
    expect(racers.map(&:distance)).to eq [1120, 1056]
    expect(racers.map(&:score)).to eq [312, 689]
  end
end
