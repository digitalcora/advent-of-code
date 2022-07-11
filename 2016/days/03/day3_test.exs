defmodule Advent.Day3Test do
  use ExUnit.Case, async: true
  alias Advent.Day3

  test "finds how many sets of 3 side lengths are valid triangles" do
    assert Day3.valid_triangles("3 4 5\n5 10 25\n2 2 3\n1 2 3") == 2
  end

  test "finds the number of valid triangles when sets are read vertically" do
    assert Day3.valid_triangles(vertical_test_input(), :vertical) == 3
  end

  defp vertical_test_input do
    """
      3  5  2
      4 10  2
      5 25  3
      1  6  1
      2  8  1
      3 10 10
    """
  end
end
