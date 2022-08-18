defmodule Advent.Day24Test do
  use ExUnit.Case, async: true
  alias Advent.Day24

  test "finds the fewest steps to visit every location starting from 0" do
    assert Day24.fewest_steps(example_map()) == 14
  end

  test "finds the fewest steps starting from location 0 and returning to 0" do
    assert Day24.fewest_steps(example_map(), true) == 20
  end

  defp example_map do
    """
    ###########
    #0.1.....2#
    #.#######.#
    #4.......3#
    ###########
    """
  end
end
