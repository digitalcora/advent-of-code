defmodule Advent.Day22Test do
  use ExUnit.Case, async: true
  alias Advent.Day22

  test "determines the count of viable pairs of nodes" do
    assert Day22.viable_pairs(example_input()) == 43
  end

  test "finds the fewest steps to move the target data to the upper-left corner" do
    assert Day22.fewest_moves(example_input()) == 39
  end

  # Build a puzzle input from an ASCII diagram using the same conventions as the example for the
  # second star.
  defp example_input do
    """
    .......
    .......
    .......
    ..#####
    .......
    ....._.
    .......
    """
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index(fn row, y -> Enum.with_index(row, &generate_node(&1, &2, y)) end)
    |> List.flatten()
    |> Enum.join("\n")
    |> then(fn input ->
      """
      root@ebhq-gridcenter# df -h
      Filesystem            Size  Used  Avail  Use%
      """ <> input
    end)
  end

  defp generate_node(ascii, x, y) do
    {size, used} =
      case ascii do
        "." -> {8 + :rand.uniform(3), 5 + :rand.uniform(3)}
        "#" -> {30 + :rand.uniform(3), 26 + :rand.uniform(3)}
        "_" -> {12, 0}
      end

    ~w(
      /dev/grid/node-x#{x}-y#{y}
      #{size}T
      #{used}T
      #{size - used}T
      #{round(used / size * 100)}
    ) |> Enum.join("    ")
  end
end
