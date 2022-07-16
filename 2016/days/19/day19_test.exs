defmodule Advent.Day19Test do
  use ExUnit.Case, async: true
  alias Advent.Day19

  test "determines which elf gets all the presents given a starting elf count" do
    assert Day19.winning_elf(5, :next) == 3
    assert Day19.winning_elf(11, :next) == 7
  end

  test "determines the winner when the steal target is the elf across the circle" do
    assert Day19.winning_elf(5, :across) == 2
    assert Day19.winning_elf(8, :across) == 7
    assert Day19.winning_elf(9, :across) == 9
  end
end
