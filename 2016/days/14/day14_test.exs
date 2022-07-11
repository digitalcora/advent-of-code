defmodule Advent.Day14Test do
  use ExUnit.Case, async: true
  alias Advent.Day14

  describe "finds the index that produces the Nth key of the one-time pad" do
    test "for small values of N" do
      assert Day14.key_index("abc", 1) == 39
      assert Day14.key_index("abc", 2) == 92
    end

    @tag :slow
    test "for large values of N" do
      assert Day14.key_index("abc", 64) == 22728
    end
  end

  describe "finds the index using a specified number of hashing rounds" do
    @describetag :slow

    test "for small values of N" do
      assert Day14.key_index("abc", 1, 2017) == 10
    end

    @tag timeout: :infinity
    test "for large values of N" do
      assert Day14.key_index("abc", 64, 2017) == 22551
    end
  end
end
