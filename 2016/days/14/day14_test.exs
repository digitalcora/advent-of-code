defmodule Advent.Day14Test do
  use ExUnit.Case
  alias Advent.Day14

  test "finds the index that produces the Nth key of the one-time pad" do
    assert Day14.key_index("abc", 1) == 39
    assert Day14.key_index("abc", 2) == 92
    assert Day14.key_index("abc", 64) == 22728
  end

  test "find the index using a specified number of rounds for hashing" do
    assert Day14.key_index("abc", 1, 2017) == 10
    # Impractically slow to include in the test suite by default (run with `--trace`)
    # assert Day14.key_index("abc", 64, 2017) == 22551
  end
end
