defmodule Advent.Day12Test do
  use ExUnit.Case, async: true
  alias Advent.Day12

  test "returns the value in register `a` after executing an Assembunny program" do
    assert Day12.final_value_in_a(test_program()) == 42
  end

  test "allows register `c` to be initialized with a value other than 0" do
    assert Day12.final_value_in_a("cpy c a\ninc a", 7) == 8
  end

  defp test_program do
    """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """
  end
end
