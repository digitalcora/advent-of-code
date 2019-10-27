defmodule Advent.Day13Test do
  use ExUnit.Case
  alias Advent.Day13

  test "finds the fewest steps required to escape the cubicle maze" do
    assert Day13.fewest_steps({7, 4}, 10) == 11
  end

  test "finds the number of locations reachable within a step limit" do
    assert Day13.reachable_locations(10, 50) == 151
  end
end
