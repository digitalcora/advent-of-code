require 'day13'

RSpec.describe Day13 do
  it 'finds the happiness totals of all possible seating arrangements' do
    totals = Day13.new(test_edges).happiness_totals
    expect(totals.max).to eq 330
  end

  it 'finds happiness totals after including an extra "neutral" guest' do
    totals = Day13.new(test_edges, add_neutral: true).happiness_totals
    expect(totals.max).to eq 286
  end

  def test_edges
    [
      'Alice would gain 54 happiness units by sitting next to Bob.',
      'Alice would lose 79 happiness units by sitting next to Carol.',
      'Alice would lose 2 happiness units by sitting next to David.',
      'Bob would gain 83 happiness units by sitting next to Alice.',
      'Bob would lose 7 happiness units by sitting next to Carol.',
      'Bob would lose 63 happiness units by sitting next to David.',
      'Carol would lose 62 happiness units by sitting next to Alice.',
      'Carol would gain 60 happiness units by sitting next to Bob.',
      'Carol would gain 55 happiness units by sitting next to David.',
      'David would gain 46 happiness units by sitting next to Alice.',
      'David would lose 7 happiness units by sitting next to Bob.',
      'David would gain 41 happiness units by sitting next to Carol.'
    ].join("\n")
  end
end
