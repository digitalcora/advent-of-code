defmodule Advent.Day10Test do
  use ExUnit.Case, async: true
  alias Advent.Day10

  test "finds the bot responsible for comparing two specific values" do
    assert Day10.bot_comparing(test_input(), 2, 5) == 2
  end

  test "multiplies the output values for a given list of outputs" do
    assert Day10.output_product(test_input(), [0, 2]) == 15
  end

  defp test_input do
    """
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    """
  end
end
