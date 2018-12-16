defmodule Advent.Day2Test do
  use ExUnit.Case
  alias Advent.Day2

  test "finds the keypad code by following the instructions" do
    assert Day2.keypad_code("ULL\nRRDDD\nLURDL\nUUUUD") == "1985"
  end

  test "finds the code on a diamond-shaped tetradecimal keypad" do
    assert Day2.keypad_code("ULL\nRRDDD\nLURDL\nUUUUD", :diamond) == "5DB3"
  end
end
