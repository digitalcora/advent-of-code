defmodule Advent.Day13 do
  defmodule Node do
    # Represents a pathfinder node for solving the cubicle maze. The shape of the maze depends on
    # its seed and the goal is arbitrary (not computed from state), so we store both.
    defstruct position: {1, 1}, seed: nil, goal: nil

    # Since steps can only be orthogonal, the H score is the Manhattan distance to the goal.
    def h_score(%__MODULE__{position: {px, py}, goal: {gx, gy}}) do
      abs(px - gx) + abs(py - gy)
    end

    # Find valid neighbors for a position. We can move in any orthogonal direction, providing
    # neither coordinate ends up negative, and there is not a wall in our way according to the
    # maze generation seed.
    def neighbors(%__MODULE__{position: {x, y}, seed: seed} = node) do
      [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
      |> Enum.filter(&is_open(&1, seed))
      |> Enum.map(fn position -> struct!(node, position: position) end)
    end

    # Determine whether a given position in the maze is open (does not contain a wall).
    defp is_open({x, y}, seed) do
      require Integer

      (x * x + 3 * x + 2 * x * y + y + y * y + seed)
      |> Integer.to_string(2)
      |> String.codepoints()
      |> Enum.count(&(&1 == "1"))
      |> Integer.is_even()
    end
  end

  alias Advent.AStar

  # 🌟 Solve the silver star.
  def fewest_steps({_, _} = goal, seed) do
    %Node{seed: seed, goal: goal} |> AStar.fewest_steps()
  end
end
