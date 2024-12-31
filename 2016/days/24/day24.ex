defmodule Advent.Day24 do
  defmodule Leg do
    # Represents a state of the maze for the purposes of pathfinding one leg of the journey.
    defstruct current: {0, 0}, goal: {0, 0}, size: {0, 0}, walls: MapSet.new()

    # Since steps can only be orthogonal, the H score is the Manhattan distance to the goal.
    def h_score(%__MODULE__{current: {cx, cy}, goal: {gx, gy}}), do: abs(cx - gx) + abs(cy - gy)

    # Find valid states that are one step away from the given state.
    def neighbors(%__MODULE__{current: {cx, cy}, size: {sx, sy}, walls: walls} = state) do
      [{cx - 1, cy}, {cx + 1, cy}, {cx, cy - 1}, {cx, cy + 1}]
      |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 and x < sx and y < sy end)
      |> Enum.filter(&(&1 not in walls))
      |> Enum.map(fn position -> %{state | current: position} end)
    end
  end

  defmodule Maze do
    # Parsed form of the duct maze provided as input.
    defstruct goals: [], size: {0, 0}, start: {0, 0}, walls: MapSet.new()
  end

  alias Advent.AStar

  # 🌟🌟 Solve either the silver or gold star.
  def fewest_steps(map, return_to_start? \\ false) do
    %Maze{goals: goals, size: size, start: start, walls: walls} = parse_input(map)

    # Get the length of the shortest path between each possible pair of locations.
    leg_steps =
      [start | goals]
      |> pairs()
      |> Stream.map(fn [a, b] ->
        {
          Enum.sort([a, b]),
          %Leg{current: a, goal: b, size: size, walls: walls}
          |> AStar.pathfind()
          |> AStar.path_length()
        }
      end)
      |> Map.new()

    # Find the sequence of goals with the shortest sum of paths from each one to the next.
    goals
    |> permutations()
    |> Enum.reduce(:infinity, fn permutation, best_steps ->
      min(
        best_steps,
        [start | permutation]
        |> Enum.chunk_every(2, 1)
        |> Enum.map(fn
          [last] ->
            if return_to_start?,
              do: Map.fetch!(leg_steps, Enum.sort([last, start])),
              else: 0

          [_, _] = leg ->
            Map.fetch!(leg_steps, Enum.sort(leg))
        end)
        |> Enum.sum()
      )
    end)
  end

  # Parse the puzzle input into a `Maze`.
  defp parse_input(map) do
    rows =
      map
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    rows
    |> Stream.with_index()
    |> Enum.reduce(%Maze{size: {length(hd(rows)), length(rows)}}, fn {row, y}, maze ->
      row
      |> Stream.with_index()
      |> Enum.reduce(maze, fn {tile, x}, %{goals: goals, walls: walls} = maze ->
        case tile do
          ?. -> maze
          ?# -> %{maze | walls: MapSet.put(walls, {x, y})}
          ?0 -> %{maze | start: {x, y}}
          char when char in ~c[123456789] -> %{maze | goals: [{x, y} | goals]}
        end
      end)
    end)
  end

  # Generate all 2-combinations of a list of items.
  defp pairs([]), do: []
  defp pairs(items), do: Enum.map(tl(items), &[hd(items), &1]) ++ pairs(tl(items))

  # Generate all permutations of a list of items.
  defp permutations(items) when is_list(items), do: items |> MapSet.new() |> permutations()

  defp permutations(%MapSet{} = items) do
    case MapSet.size(items) do
      0 ->
        []

      1 ->
        [MapSet.to_list(items)]

      _ ->
        Enum.flat_map(items, fn item ->
          items |> MapSet.delete(item) |> permutations() |> Enum.map(&[item | &1])
        end)
    end
  end
end
