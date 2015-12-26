require 'day18'

RSpec.describe Day18 do
  it 'finds the number of live cells after a given number of generations' do
    test_grid = %w(
      .#.#.#
      ...##.
      #....#
      ..#...
      #.#..#
      ####..
    ).join("\n")

    expect(Day18.new(test_grid).live_cells_at(4)).to eq 4
  end
end
