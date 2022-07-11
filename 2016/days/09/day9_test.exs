defmodule Advent.Day9Test do
  use ExUnit.Case, async: true
  alias Advent.Day9

  test "finds the original size of data packed in an experimental format" do
    assert Day9.unpacked_size("ADVENT") == 6
    assert Day9.unpacked_size("A(1x5)BC") == 7
    assert Day9.unpacked_size("(3x3)XYZ") == 9
    assert Day9.unpacked_size("A(2x2)BCD(2x2)EFG") == 11
    assert Day9.unpacked_size("(6x1)(1x3)A") == 6
    assert Day9.unpacked_size("X(8x2)(3x3)ABCY") == 18
  end

  test "finds the original size of the data if version 2 of the format is used" do
    assert Day9.unpacked_size("(3x3)XYZ", 2) == 9
    assert Day9.unpacked_size("X(8x2)(3x3)ABCY", 2) == 20
    assert Day9.unpacked_size("(27x12)(20x12)(13x14)(7x10)(1x12)A", 2) == 241_920
    long_input = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
    assert Day9.unpacked_size(long_input, 2) == 445
  end
end
