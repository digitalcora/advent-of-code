defmodule Advent.Day25Test do
  use ExUnit.Case, async: true
  alias Advent.Day25

  test "finds the smallest positive value for register A that generates a clock signal" do
    assert Day25.clock_signal_key(example_program()) == 5
  end

  defp example_program do
    # Minimal program that outputs the clock signal `0 1 0 1 ...` when A is initialized to 5.
    """
    cpy 5 b
    dec a
    dec b
    jnz b -2
    out a
    inc a
    out a
    dec a
    jnz 1 -4
    """
  end
end
