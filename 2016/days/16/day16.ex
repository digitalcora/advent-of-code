defmodule Advent.Day16 do
  # 🌟🌟 Solve either the silver or gold star.
  def checksum(initial_data, disk_size) do
    initial_data
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> expand_data(disk_size)
    |> checksum_data()
    |> Enum.join()
  end

  defp expand_data(initial_data, disk_size) do
    initial_data
    |> Stream.iterate(fn data ->
      Enum.concat([data, [0], data |> Enum.reverse() |> Enum.map(&invert/1)])
    end)
    |> Enum.find(&(length(&1) >= disk_size))
    |> Enum.slice(0..(disk_size - 1))
  end

  defp checksum_data(data) do
    data
    |> Stream.iterate(fn data ->
      data |> Stream.chunk_every(2) |> Enum.map(&checksum_pair/1)
    end)
    # `iterate` includes the initial value, which we don't want to consider
    |> Stream.drop(1)
    |> Enum.find(&(rem(length(&1), 2) == 1))
  end

  defp checksum_pair([a, b]) when a == b, do: 1
  defp checksum_pair(_), do: 0

  defp invert(0), do: 1
  defp invert(1), do: 0
end
