defmodule Advent.AStar do
  @moduledoc "Generic A* pathfinder."

  # Given a struct representing a starting node, returns the fewest number of steps required to
  # reach a goal, or `nil` if the goal is unreachable. The struct's module is expected to define
  # these functions:
  #
  #   `h_score/1` — Estimate the number of steps to reach the goal from a given node. Must
  #                 return 0 if-and-only-if the node is at the goal.
  #   `neighbors/1` — Return a list of nodes that are one step away from a given node.
  def fewest_steps(%{__struct__: module} = start_node) do
    pathfind(%{
      module: module,
      open: MapSet.new([start_node]),
      closed: MapSet.new(),
      g_scores: %{start_node => 0},
      h_scores: %{start_node => module.h_score(start_node)},
      inverse_f: %{module.h_score(start_node) => MapSet.new([start_node])}
    })
  end

  # Pathfinder iteration. Reference for the `state` map:
  #   `module` — the module that provides H-score and neighbor functions.
  #   `open` — the set of nodes we have discovered and still need to explore.
  #   `closed` — the set of nodes we have discovered and explored (discovered all neighbors).
  #   `g_scores` — maps nodes to G scores (fewest steps ever taken to reach the node).
  #   `h_scores` — maps nodes to H scores (estimated distance from the node to the goal).
  #   `inverse_f` — maps F scores (G+H) to the set of *open* nodes with that score. This acts
  #                 as a priority queue for the most promising nodes to explore next.
  defp pathfind(state) do
    current = most_promising_node(state)

    cond do
      is_nil(current) ->
        # We explored all possible nodes and still didn't reach the goal.
        nil

      state.h_scores[current] == 0 ->
        # We're at the goal, so return the number of steps taken to get here.
        state.g_scores[current]

      true ->
        # We're not at the goal yet and still have open nodes to explore.
        # Discover this node's neighbors, then close it and proceed to the next iteration.
        current
        |> state.module.neighbors()
        |> Enum.reduce(state, fn neighbor, state ->
          g_current = state.g_scores[current]
          g_neighbor = state.g_scores[neighbor]
          h_neighbor = state.module.h_score(neighbor)

          # (Re)open this neighbor for consideration if we've either never seen it, or found a
          # shorter path to it than the last time we saw it.
          if is_nil(g_neighbor) or g_current + 1 < g_neighbor do
            state |> open(neighbor, g_current + 1, h_neighbor)
          else
            state
          end
        end)
        |> close(current)
        |> pathfind()
    end
  end

  # Get an arbitrary node from the set of open nodes having the lowest F score.
  defp most_promising_node(%{inverse_f: inverse_f}) do
    inverse_f
    |> Map.keys()
    |> Enum.sort()
    |> Stream.map(&inverse_f[&1])
    |> Stream.reject(&is_nil/1)
    |> Stream.reject(&(MapSet.size(&1) == 0))
    |> Enum.at(0, MapSet.new())
    |> Enum.at(0, nil)
  end

  # Close a node, indicating its neighbors have been discovered and scored.
  defp close(state, node) do
    state
    |> update_in([:open], &MapSet.delete(&1, node))
    |> update_in([:closed], &MapSet.put(&1, node))
    |> remove_from_queue(node)
  end

  # Open a node, indicating it should be explored, and assign its G and H scores.
  defp open(state, node, g_score, h_score) do
    state
    |> remove_from_queue(node)
    |> update_in([:closed], &MapSet.delete(&1, node))
    |> update_in([:open], &MapSet.put(&1, node))
    |> put_in([:g_scores, node], g_score)
    |> put_in([:h_scores, node], h_score)
    |> add_to_queue(node)
  end

  defp add_to_queue(state, node) do
    f_score = state.g_scores[node] + state.h_scores[node]

    state
    |> update_in([:inverse_f, f_score], &if(is_nil(&1), do: MapSet.new(), else: &1))
    |> update_in([:inverse_f, f_score], &MapSet.put(&1, node))
  end

  defp remove_from_queue(state, node) do
    g_score = state.g_scores[node]
    h_score = state.h_scores[node]

    if is_nil(g_score) or is_nil(h_score) do
      # We can assume the node was not in the queue to begin with.
      state
    else
      state
      |> update_in([:inverse_f, g_score + h_score], &if(is_nil(&1), do: MapSet.new(), else: &1))
      |> update_in([:inverse_f, g_score + h_score], &MapSet.delete(&1, node))
    end
  end
end
