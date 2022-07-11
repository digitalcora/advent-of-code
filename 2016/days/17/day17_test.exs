defmodule Advent.Day17Test do
  use ExUnit.Case, async: true
  alias Advent.Day17

  test "finds the shortest path to the vault given an initial passcode" do
    assert Day17.shortest_path("ihgpwlah") == "DDRRRD"
    assert Day17.shortest_path("kglvqrro") == "DDUDRLRRUDRD"
    assert Day17.shortest_path("ulqzkmiv") == "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  end

  test "finds the length of the longest path to the vault that does not pass through it" do
    assert Day17.longest_path_length("ihgpwlah") == 370
    assert Day17.longest_path_length("kglvqrro") == 492
    assert Day17.longest_path_length("ulqzkmiv") == 830
  end
end
