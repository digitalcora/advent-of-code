defmodule Advent.Day15Test do
  use ExUnit.Case
  alias Advent.Day15

  test "finds the earliest time when a dropped capsule will make it through the sculpture" do
    assert Day15.ideal_drop_time(test_input()) == 5
  end

  defp test_input do
    """
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
    """
  end
end
