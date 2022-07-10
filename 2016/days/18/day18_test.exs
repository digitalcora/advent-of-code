defmodule Advent.Day18Test do
  use ExUnit.Case
  alias Advent.Day18

  test "returns a count of safe tiles given the contents of the first row" do
    assert Day18.safe_count("..^^.", 3) == 6
    assert Day18.safe_count(".^^.^.^^^^", 10) == 38
  end
end
