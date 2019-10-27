defmodule Advent.Day11 do
  defmodule Node do
    # Represents a pathfinder node in the space of possible states for the lab. `elevator` is the
    # current floor and `pairs` is a term-sorted list of generator/microchip pairs that share an
    # element, in the form `%{generator: X, microchip: Y}` where X and Y are floors. Omitting the
    # elements themselves is critical, otherwise A* gets bogged down exploring element-swapped
    # versions of states it has already evaluated (which have identical steps to reach the goal).
    defstruct elevator: 1, pairs: []

    # The lab always has four floors.
    @top_floor 4

    # Calculate a node's H score (estimated distance to goal) for A* pathfinding, which we say is
    # the sum of the distances of each object from the top floor. Unsure whether this is actually
    # admissible; lower scores are always closer to the goal, but the score is usually greater
    # than the true number of steps required. It gets the shortest path for the input data I had!
    def h_score(%__MODULE__{pairs: pairs}) do
      pairs |> Enum.flat_map(&Map.values/1) |> Enum.map(&(@top_floor - &1)) |> Enum.sum()
    end

    # Find all valid states that can be reached from a given state in one step.
    def neighbors(%__MODULE__{elevator: elevator, pairs: pairs}) do
      # We can move one floor up or down, provided there is a floor above or below us.
      destination_floors = Enum.filter([elevator + 1, elevator - 1], &(&1 in 1..@top_floor))

      # We must move either 1 or 2 objects from the floor we're leaving. Since objects are stored
      # as anonymous pairs of generator and microchip, we have to convert to a flat list of single
      # objects, along with their index in `pairs` so we can find them again later.
      object_combinations =
        pairs
        |> Enum.with_index()
        |> Enum.flat_map(fn {%{generator: gen_floor, microchip: chip_floor}, index} ->
          [{index, :generator, gen_floor}, {index, :microchip, chip_floor}]
        end)
        |> Enum.filter(fn {_, _, floor} -> floor == elevator end)
        |> combinations()

      # Find the resulting states if we take each possible combination of objects with us to each
      # destination floor, discarding duplicate and invalid states.
      destination_floors
      |> Enum.flat_map(fn new_floor ->
        Enum.map(object_combinations, fn combination ->
          new_pairs =
            Enum.reduce(combination, pairs, fn {index, type, _}, pairs ->
              List.update_at(pairs, index, &Map.put(&1, type, new_floor))
            end)

          # We need to sort the anonymous pairs to ensure moves that are functionally equivalent
          # will result in identical pathfinder nodes.
          %__MODULE__{elevator: new_floor, pairs: Enum.sort(new_pairs)}
        end)
      end)
      |> Enum.uniq()
      |> Enum.filter(&valid?/1)
    end

    # Generate all 1- and 2-combinations of a list of items.
    defp combinations([]), do: []
    defp combinations([item]), do: [[item]]

    defp combinations(items) do
      [[hd(items)] | Enum.map(tl(items), &[hd(items), &1]) ++ combinations(tl(items))]
    end

    # From the problem statement, if a chip is on the same floor as a different chip's generator
    # AND its own generator is not on that floor, the chip will be fried. Such states should not
    # be considered for pathfinding.
    defp valid?(%__MODULE__{pairs: pairs}) do
      floors_with_generators = pairs |> Enum.map(& &1.generator) |> Enum.uniq()

      Enum.all?(floors_with_generators, fn floor ->
        pairs |> Enum.filter(&(&1.microchip == floor)) |> Enum.all?(&(&1.generator == floor))
      end)
    end
  end

  defmodule Input do
    # Distill the puzzle input into an initial `Node` suitable for pathfinding.
    def parse(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce(%{}, &parse_floor/2)
      |> initialize_node()
    end

    @floor ~r/^The (?<ordinal>\w+) floor contains (?<objects>nothing relevant|.+)\.$/
    @object ~r/(?:a (?<element>\w+)(?:-compatible)? (?<type>generator|microchip))+/
    @ordinals %{"first" => 1, "second" => 2, "third" => 3, "fourth" => 4}

    # Parse a single line of the input and add the results to an intermediate `elements` map,
    # which is like `pairs` but retains the element information so new objects can be paired up as
    # they are discovered.
    defp parse_floor(line, elements) do
      %{"ordinal" => ordinal, "objects" => objects_string} = Regex.named_captures(@floor, line)

      objects_string
      |> parse_objects()
      |> Enum.reduce(elements, fn %{element: element, type: type}, elements ->
        elements
        |> Map.put_new(element, %{})
        |> put_in([element, type], Map.fetch!(@ordinals, ordinal))
      end)
    end

    defp parse_objects("nothing relevant"), do: []

    defp parse_objects(objects) do
      objects
      |> String.split(~r/, and|,|and/)
      |> Enum.map(&Regex.named_captures(@object, &1))
      |> Enum.map(fn %{"element" => element, "type" => type} ->
        %{element: String.to_atom(element), type: String.to_atom(type)}
      end)
    end

    defp initialize_node(elements) do
      # Discard the intermediate element data and sort the now-anonymous pairs of objects.
      %Node{pairs: elements |> Map.values() |> Enum.sort()}
    end
  end

  defmodule AStar do
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

  # 🌟🌟 Solve either the silver or gold star.
  def fewest_steps(input) do
    input |> Input.parse() |> AStar.fewest_steps()
  end
end
