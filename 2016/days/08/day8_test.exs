defmodule Advent.Day8Test do
  use ExUnit.Case, async: true
  alias Advent.Day8

  test "determines how many pixels are lit after a set of instructions is run" do
    assert Day8.pixel_count(test_instructions(), 7, 3) == 6
  end

  test "produces an ASCII schematic of the pixels after the instructions are run" do
    assert Day8.pixel_ascii(test_instructions(), 7, 3) == String.trim(expected_ascii())
  end

  defp test_instructions do
    """
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
    """
  end

  defp expected_ascii do
    """
    .#..#.#
    #.#....
    .#.....
    """
  end
end
