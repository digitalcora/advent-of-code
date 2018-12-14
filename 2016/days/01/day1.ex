defmodule Advent.Day1 do
  defmodule Input do
    def parse(instructions) do
      instructions |> String.split(", ") |> Enum.flat_map(&expand/1)
    end

    defp expand(instruction) do
      {direction, distance} = String.split_at(instruction, 1)

      [
        Map.fetch!(%{"L" => :left, "R" => :right}, direction)
        | List.duplicate(:forward, String.to_integer(distance))
      ]
    end
  end

  defmodule Walk do
    defstruct heading: :north, location: {0, 0}, has_path_crossed: false, visited: MapSet.new()

    def distance_from_origin(%{location: {x, y}}) do
      abs(x) + abs(y)
    end

    def go(%{heading: heading, location: location} = walk, :forward) do
      location = advance(location, heading)

      case location in walk.visited do
        true -> struct!(walk, location: location, has_path_crossed: true)
        false -> struct!(walk, location: location, visited: MapSet.put(walk.visited, location))
      end
    end

    def go(%{heading: heading} = walk, direction) when direction in [:left, :right] do
      struct!(walk, heading: turn(heading, direction))
    end

    defp advance({x, y}, :north), do: {x, y - 1}
    defp advance({x, y}, :south), do: {x, y + 1}
    defp advance({x, y}, :west), do: {x - 1, y}
    defp advance({x, y}, :east), do: {x + 1, y}

    defp turn(:north, :left), do: :west
    defp turn(:west, :left), do: :south
    defp turn(:south, :left), do: :east
    defp turn(:east, :left), do: :north
    defp turn(:north, :right), do: :east
    defp turn(:east, :right), do: :south
    defp turn(:south, :right), do: :west
    defp turn(:west, :right), do: :north
  end

  def distance_to_end(instructions) do
    instructions
    |> Input.parse()
    |> Enum.reduce(%Walk{}, fn step, walk -> Walk.go(walk, step) end)
    |> Walk.distance_from_origin()
  end

  def distance_to_cross(instructions) do
    instructions
    |> Input.parse()
    |> Enum.reduce_while(%Walk{}, fn step, walk ->
      case Walk.go(walk, step) do
        %{has_path_crossed: true} = walk -> {:halt, walk}
        %{has_path_crossed: false} = walk -> {:cont, walk}
      end
    end)
    |> Walk.distance_from_origin()
  end
end
