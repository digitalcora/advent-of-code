defmodule Advent.Day1Test do
  use ExUnit.Case, async: true
  alias Advent.Day1

  test "finds the shortest taxicab distance to the end of the path" do
    assert Day1.distance_to_end("R2, L3") == 5
    assert Day1.distance_to_end("R2, R2, R2") == 2
    assert Day1.distance_to_end("R5, L5, R5, R3") == 12
  end

  test "finds the shortest taxicab distance to the first path-cross" do
    assert Day1.distance_to_cross("R8, R4, R4, R8") == 4
  end
end
