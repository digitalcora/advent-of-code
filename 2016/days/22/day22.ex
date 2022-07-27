defmodule Advent.Day22 do
  defmodule Grid do
    # Represents a simplified version of the storage grid which is assumed to have:
    #   * a subset of nodes with data large enough that it can never be moved ("blocked")
    #   * exactly one empty node which can fit the data of all non-blocked nodes (the "hole")
    #
    # All other nodes are assumed to also be large enough to hold each others' data, but filled
    # with enough data that the only way to transfer it out would be into the "hole", effectively
    # moving the hole around.
    #
    # These assumptions are true for all official puzzle inputs, and by admission of the puzzle's
    # author, may be required for it to be "generally" solvable at all. See discussion at:
    # https://www.reddit.com/r/adventofcode/comments/5jor9q/2016_day_22_solutions/dbj526y/?context=8&depth=9

    defstruct blocked: MapSet.new(), hole: {0, 0}, size: {0, 0}

    # For use with `AStar` we are specifically interested in getting the "hole" to the location
    # just left of the target data in the upper-right corner. Data can only move orthogonally, so
    # the H score is the Manhattan distance of the hole from this location.
    def h_score(%__MODULE__{hole: {hx, hy}, size: {sx, _sy}}), do: sx - hx - 2 + hy

    # Find valid states that are one step away from the given state. We can "move" the hole (by
    # moving an adjacent node's data into it) if the destination is within the bounds of the grid
    # and is not "blocked" (has data too large to move into the hole).
    def neighbors(%__MODULE__{blocked: blocked, hole: {hx, hy}, size: {sx, sy}} = state) do
      [{hx - 1, hy}, {hx + 1, hy}, {hx, hy - 1}, {hx, hy + 1}]
      |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 and x < sx and y < sy end)
      |> Enum.filter(&(&1 not in blocked))
      |> Enum.map(fn dest -> %{state | hole: dest} end)
    end
  end

  alias Advent.AStar

  # 🌟 Solve the silver star.
  def viable_pairs(input) do
    %Grid{blocked: blocked, size: {sx, sy}} = parse_input(input)

    # Every non-blocked node's data could be moved into the hole, excepting the hole itself. No
    # other moves are possible.
    sx * sy - MapSet.size(blocked) - 1
  end

  # 🌟 Solve the gold star.
  def fewest_moves(input) do
    %Grid{size: {sx, _sy}} = grid = parse_input(input)
    hole_moves = grid |> AStar.pathfind() |> AStar.path_length()

    # From a state where the hole is directly left of the target data (the pathfinding goal),
    # moving the target data one node left requires 1 step to move it into the hole, then 4 steps
    # to shuffle the hole back into position, for a total of 5. This is true for each move except
    # the last, where we are done after 1 step since the target data is at 0,0.
    hole_moves + (sx - 2) * 5 + 1
  end

  # Distill the puzzle input into a `Grid`, validating some assumptions along the way.
  def parse_input(input) do
    nodes =
      input
      |> String.splitter("\n", trim: true)
      # the first two lines are the "command" and the headers
      |> Stream.drop(2)
      |> Stream.map(&String.split/1)
      |> Stream.map(fn [name, size, used, _available, _percent] ->
        [x, y] =
          ~r/x(\d+)-y(\d+)/
          |> Regex.run(name, capture: :all_but_first)
          |> Enum.map(&String.to_integer/1)

        {{x, y}, {terabytes(size), terabytes(used)}}
      end)
      |> Map.new()

    max_x = nodes |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = nodes |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
    {target_size, target_used} = Map.fetch!(nodes, {max_x, 0})

    blocked =
      nodes
      |> Enum.filter(fn {{_x, _y}, {_size, used}} -> used > target_size end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    # Validate there is exactly one "hole".
    [{{hx, hy}, _stats}] = Enum.filter(nodes, fn {_xy, {_size, used}} -> used == 0 end)

    # Validate all non-blocked nodes can hold the target data.
    others = Enum.filter(nodes, fn {xy, _stats} -> xy not in blocked and xy != {hx, hy} end)
    ^others = Enum.filter(others, fn {_xy, {size, _used}} -> size >= target_used end)

    # Validate there are no blocked nodes in the top two rows. This allows a simplification of
    # the solution where, once the hole is moved to the target data, it can be shuffled around
    # in a fixed pattern to move the data left in a straight line to the goal.
    [] = Enum.filter(nodes, fn {{x, y}, _stats} -> y in [0, 1] and {x, y} in blocked end)

    %Grid{blocked: blocked, hole: {hx, hy}, size: {max_x + 1, max_y + 1}}
  end

  defp terabytes(human_size), do: human_size |> String.trim_trailing("T") |> String.to_integer()
end
