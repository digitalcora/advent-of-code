defmodule Advent.Day5Test do
  use ExUnit.Case
  alias Advent.Day5

  test "cracks the password for a given door ID" do
    assert Day5.crack_password("abc") == "18f47a30"
  end

  test "cracks the password using the War Games algorithm" do
    assert Day5.crack_password("abc", :war_games) == "05ace8e3"
  end
end
