defmodule Advent.Day22 do
  # 🌟 Solve the silver star.
  def viable_pairs_count(input), do: input |> parse_input() |> viable_pairs() |> Enum.count()

  defp parse_input(input) do
    input
    |> String.splitter("\n", trim: true)
    # the first two lines are the "command" and the headers
    |> Stream.drop(2)
    |> Stream.map(&String.split/1)
    |> Enum.map(fn [name, size, used, _available, _use_percent] ->
      {name, terabytes(size), terabytes(used)}
    end)
  end

  defp terabytes(human_size), do: human_size |> String.trim_trailing("T") |> String.to_integer()

  defp viable_pairs(nodes), do: nodes |> permutations() |> Stream.filter(&viable?/1)

  # Stream all 2-permutations of the given items.
  defp permutations(items) do
    items
    |> Stream.unfold(fn
      [_last] -> nil
      [head | tail] -> {Stream.map(tail, &{head, &1}), tail}
    end)
    |> Stream.flat_map(& &1)
    |> Stream.flat_map(fn {a, b} -> [{a, b}, {b, a}] end)
  end

  # Determine whether a given node's data could be moved to a given other node.
  defp viable?({{_name_a, _size_a, used_a}, {_name_b, size_b, used_b}}),
    do: used_a > 0 and used_a <= size_b - used_b
end
