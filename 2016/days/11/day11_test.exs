defmodule Advent.Day11Test do
  use ExUnit.Case
  alias Advent.Day11

  test "finds the fewest elevator steps required to bring all objects to the top floor" do
    assert Day11.fewest_steps(test_input_simple()) == 11
  end

  test "finds the fewest steps for a more complex input in a reasonable amount of time" do
    # n.b. this uses my actual puzzle input. Spoilers!
    assert Day11.fewest_steps(test_input_complex()) == 37
  end

  defp test_input_simple do
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
  end

  defp test_input_complex do
    """
    The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
    The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
    The third floor contains a thulium-compatible microchip.
    The fourth floor contains nothing relevant.
    """
  end
end
