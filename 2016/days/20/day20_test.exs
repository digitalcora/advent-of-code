defmodule Advent.Day20Test do
  use ExUnit.Case, async: true
  alias Advent.Day20

  @example_input ~w(5-8 0-2 4-7) |> Enum.join("\n")
  @input_without_0 ~w(5-8 1-3 4-7) |> Enum.join("\n")

  test "finds the lowest IP not within the blocked ranges" do
    assert Day20.lowest_allowed_ip(@example_input) == 3
    assert Day20.lowest_allowed_ip(@input_without_0) == 0
  end

  test "determines how many IPs are allowed by the blocked ranges" do
    assert Day20.allowed_ip_count(@example_input, 9) == 2
    assert Day20.allowed_ip_count(@input_without_0, 9) == 2
  end
end
