require 'day18'

RSpec.describe Day18 do
  it 'finds the number of live cells after a given number of generations' do
    expect(Day18.new(test_grid).live_cells_at(4)).to eq 4
  end

  it 'finds the number of live cells when the four corner cells are stuck' do
    expect(Day18.new(test_grid, stuck_corners: true).live_cells_at(5)).to eq 17
  end

  def test_grid
    %w(
      .#.#.#
      ...##.
      #....#
      ..#...
      #.#..#
      ####..
    ).join("\n")
  end
end
