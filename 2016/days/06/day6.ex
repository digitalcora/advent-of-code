defmodule Advent.Day6 do
  def decode(input, algorithm \\ :most_common) do
    input |> String.split() |> pivot() |> Enum.map(&hidden_letter(&1, algorithm)) |> Enum.join()
  end

  defp hidden_letter(string, :most_common) do
    string |> letter_frequencies() |> Enum.sort_by(&elem(&1, 1), &>=/2) |> hd() |> elem(0)
  end

  defp hidden_letter(string, :least_common) do
    string |> letter_frequencies() |> Enum.sort_by(&elem(&1, 1)) |> hd() |> elem(0)
  end

  defp letter_frequencies(string) do
    string
    |> String.codepoints()
    |> Enum.reduce(%{}, fn char, freqs -> Map.update(freqs, char, 1, &(&1 + 1)) end)
  end

  defp pivot(lines) do
    nil_columns = List.duplicate(nil, String.length(hd(lines)))

    {columns, _} =
      Enum.map_reduce(nil_columns, lines, fn _, chopped_lines ->
        {chopped_lines, column} =
          Enum.map_reduce(chopped_lines, "", fn line, column ->
            {first, rest} = String.split_at(line, 1)
            {rest, column <> first}
          end)

        {column, chopped_lines}
      end)

    columns
  end
end
