defmodule Advent.Day6 do
  # 🌟🌟 Solve either the silver or gold star.
  def decode(input, algorithm \\ :most_common) do
    input |> columns() |> Enum.map(&hidden_letter(&1, algorithm)) |> Enum.join()
  end

  # Find the most or least common character in a string. The puzzle doesn't specify how ties are
  # broken, and no ties occur in the examples or puzzle input, so this is left undefined.

  defp hidden_letter(string, :most_common), do: hidden_letter(string, :desc)
  defp hidden_letter(string, :least_common), do: hidden_letter(string, :asc)

  defp hidden_letter(string, freq_sort) do
    string
    |> String.codepoints()
    |> Enum.frequencies()
    |> Enum.sort_by(&elem(&1, 1), freq_sort)
    |> hd()
    |> elem(0)
  end

  # Taking the input as a grid of characters, return the strings formed by reading each column of
  # characters (starting on the left) from top to bottom. Not the most efficient approach, but the
  # input size is very small.
  defp columns(input) do
    lines = String.split(input)
    last_column_index = String.length(hd(lines)) - 1

    Enum.map(0..last_column_index, fn index ->
      lines |> Enum.map(&String.at(&1, index)) |> Enum.join()
    end)
  end
end
