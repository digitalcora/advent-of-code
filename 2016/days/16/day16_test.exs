defmodule Advent.Day16Test do
  use ExUnit.Case, async: true
  alias Advent.Day16

  test "calculates the checksum after filling a given disk using the dragon curve" do
    assert Day16.checksum("10000", 20) == "01100"
  end
end
