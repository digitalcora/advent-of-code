defmodule Advent.Day1 do
  defmodule Input do
    # Parse the raw input into a list of turns or single steps forward, e.g. "R2, L1" becomes
    # [:right, :forward, :forward, :left, :forward]. This makes it straightforward to simulate the
    # walk one step at a time and thus know when the path first crosses itself.
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
    # Represents the current state of a simulated walk through a city grid. Keeps track of the
    # current coordinates, current heading (which direction "forward" is), the set of coordinates
    # that have been visited, and whether the path has ever crossed itself.
    defstruct heading: :north, location: {0, 0}, has_path_crossed: false, visited: MapSet.new()

    def distance_from_origin(%__MODULE__{location: {x, y}}) do
      abs(x) + abs(y)
    end

    # Walk one step in the direction of the current heading.
    def go(%__MODULE__{} = walk, :forward) do
      new_location = advance(walk.location, walk.heading)

      %__MODULE__{
        walk
        | location: new_location,
          has_path_crossed: walk.has_path_crossed or new_location in walk.visited,
          visited: MapSet.put(walk.visited, new_location)
      }
    end

    # Turn the current heading 90 degrees to the left or right.
    def go(%__MODULE__{heading: heading} = walk, direction) when direction in [:left, :right] do
      %__MODULE__{walk | heading: turn(heading, direction)}
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

  # 🌟 Solve the silver star.
  def distance_to_end(instructions) do
    instructions
    |> Input.parse()
    |> Enum.reduce(%Walk{}, fn step, walk -> Walk.go(walk, step) end)
    |> Walk.distance_from_origin()
  end

  # 🌟 Solve the gold star.
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
