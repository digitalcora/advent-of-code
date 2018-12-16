defmodule Advent.Day3 do
  def valid_triangles(input, reading_direction \\ :horizontal) do
    input |> parse_input(reading_direction) |> Enum.count(&valid_triangle?/1)
  end

  defp parse_input(input, :horizontal) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.sort()
    end)
  end

  defp parse_input(input, :vertical) do
    numbers = String.split(input)

    [numbers, tl(numbers), tl(tl(numbers))]
    |> Enum.flat_map(fn offset_numbers ->
      offset_numbers
      |> Enum.take_every(3)
      |> Enum.chunk_every(3)
      |> Enum.map(fn sides -> sides |> Enum.map(&String.to_integer/1) |> Enum.sort() end)
    end)
  end

  defp valid_triangle?([a, b, c]) when a + b > c, do: true
  defp valid_triangle?(_), do: false
end
