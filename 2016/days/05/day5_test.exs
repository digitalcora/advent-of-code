defmodule Advent.Day5Test do
  use ExUnit.Case, async: true
  alias Advent.Day5

  @tag :slow
  test "cracks the password for a given door ID" do
    assert Day5.crack_password("abc") == "18f47a30"
  end

  @tag :slow
  test "cracks the password using the War Games algorithm" do
    assert Day5.crack_password("abc", :war_games) == "05ace8e3"
  end
end
