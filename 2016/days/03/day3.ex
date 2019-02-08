defmodule Advent.Day3 do
  # 🌟🌟 Solve either the silver or gold star.
  def valid_triangles(input, reading_direction \\ :horizontal) do
    input |> parse_input(reading_direction) |> Enum.count(&valid_triangle?/1)
  end

  # Parse the puzzle input into a list of triangles, represented as sorted lists of side lengths.
  # Each line of the input is read as one triangle.
  defp parse_input(input, :horizontal) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.sort()
    end)
  end

  # As above, but side lengths are read top-to-bottom within each (whitespace-delimited) column.
  # This assumes the input has exactly 3 columns of equal length.
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

  # A triangle is valid if the sum of its two shortest sides is greater than its longest side.
  defp valid_triangle?([a, b, c]) when a + b > c, do: true
  defp valid_triangle?(_), do: false
end
