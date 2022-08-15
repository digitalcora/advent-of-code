defmodule Advent.Day23Test do
  use ExUnit.Case, async: true
  alias Advent.Day23

  test "initializes register A to 7 and determines its final value" do
    assert Day23.decoded_value(example_input()) == 3
  end

  defp example_input do
    """
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
    """
  end
end
