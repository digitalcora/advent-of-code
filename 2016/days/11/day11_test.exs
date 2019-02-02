defmodule Advent.Day11Test do
  use ExUnit.Case
  alias Advent.Day11

  test "finds the minimum number of elevator steps to bring all objects to the top floor" do
    assert Day11.least_steps(test_input()) == 11
  end

  defp test_input do
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
  end
end
