defmodule Advent.Day17 do
  defmodule State do
    @max_x 3
    @max_y 3

    # Encodes a position in the maze and the moves taken to get there. The starting point is the
    # upper-left corner.
    defstruct moves: "", position: {0, 0}

    # The vault is at the bottom-right corner of the maze.
    def done?(%__MODULE__{position: {@max_x, @max_y}}), do: true
    def done?(%__MODULE__{}), do: false

    # Find valid "next" states for a position. We can move in any orthogonal direction not beyond
    # the edges of the maze or blocked by a door according to the given passcode.
    def next(%__MODULE__{moves: moves, position: {x, y}}, passcode) do
      hash = :crypto.hash(:md5, passcode <> moves)

      [{"U", x, y - 1}, {"D", x, y + 1}, {"L", x - 1, y}, {"R", x + 1, y}]
      |> Enum.filter(fn {_, x, y} -> in_bounds?(x, y) end)
      |> Enum.filter(fn {move, _, _} -> can_move?(move, hash) end)
      |> Enum.map(fn {move, x, y} -> %__MODULE__{moves: moves <> move, position: {x, y}} end)
    end

    # Determine whether moving in a direction is allowed given a passcode hash. True if, in the
    # base16 string form of the hash, the character in a specific position is "b", "c", "d", "e",
    # or "f", corresponding to a 4-bit value greater than 10.
    defp can_move?("U", <<nibble::4, _::124>>) when nibble > 10, do: true
    defp can_move?("D", <<_::4, nibble::4, _::120>>) when nibble > 10, do: true
    defp can_move?("L", <<_::8, nibble::4, _::116>>) when nibble > 10, do: true
    defp can_move?("R", <<_::12, nibble::4, _::112>>) when nibble > 10, do: true
    defp can_move?(_, _), do: false

    # Determine whether a position is within the bounds of the maze.
    defp in_bounds?(x, y), do: x >= 0 and y >= 0 and x <= @max_x and y <= @max_y
  end

  # 🌟 Solve the silver star.
  def shortest_path(passcode) do
    all_paths(passcode) |> Enum.min_by(&byte_size/1)
  end

  # 🌟 Solve the gold star.
  def longest_path_length(passcode) do
    all_paths(passcode) |> Enum.max_by(&byte_size/1) |> then(&byte_size/1)
  end

  # Find all move sequences that reach the vault.
  defp all_paths(passcode), do: {[%State{}], []} |> explore(passcode) |> Enum.map(& &1.moves)

  # Breadth-first search. Repeatedly take one step in each possible direction from every reached
  # state that is not "done". When all states are "done", we have traversed all possible paths.
  defp explore({[], done}, _), do: done

  defp explore({working, done}, passcode) do
    {new_done, new_working} =
      working
      |> Enum.flat_map(&State.next(&1, passcode))
      |> Enum.split_with(&State.done?/1)

    explore({new_working, new_done ++ done}, passcode)
  end
end
