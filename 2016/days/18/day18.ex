defmodule Advent.Day18 do
  # 🌟🌟 Solve either the silver or gold star.
  def safe_count(first_row, row_count) do
    first_row
    |> String.to_charlist()
    |> Stream.iterate(&next_row/1)
    |> Stream.take(row_count)
    |> Stream.concat()
    |> Enum.count(&safe?/1)
  end

  defp next_row(row) do
    # For the purposes of generating the next row, each row effectively has an extra untrapped
    # tile on each end.
    ('.' ++ row ++ '.')
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&next_tile/1)
  end

  defp next_tile('^^.'), do: ?^
  defp next_tile('.^^'), do: ?^
  defp next_tile('^..'), do: ?^
  defp next_tile('..^'), do: ?^
  defp next_tile([_, _, _]), do: ?.

  defp safe?(?.), do: true
  defp safe?(?^), do: false
end
