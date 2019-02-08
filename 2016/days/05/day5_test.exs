defmodule Advent.Day5Test do
  use ExUnit.Case
  alias Advent.Day5

  # These are very slow, but I feel obligated to include them since they are the official example
  # inputs. TODO: Hack in a way to decrease the difficulty of the "mining" similar to 2015 Day 4.

  test "cracks the password for a given door ID" do
    assert Day5.crack_password("abc") == "18f47a30"
  end

  test "cracks the password using the War Games algorithm" do
    assert Day5.crack_password("abc", :war_games) == "05ace8e3"
  end
end
