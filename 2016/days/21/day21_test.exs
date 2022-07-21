defmodule Advent.Day21Test do
  use ExUnit.Case, async: true
  alias Advent.Day21

  test "scrambles a password using the given rules" do
    assert Day21.scramble("abcde", example_rules()) == "decab"
  end

  test "unscrambles a password using the given rules" do
    assert Day21.unscramble("decab", example_rules()) == "abcde"
  end

  defp example_rules do
    """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """
  end
end
