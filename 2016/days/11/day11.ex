defmodule Advent.Day11 do
  defmodule Node do
    defstruct elevator: 1, pairs: [], top_floor: nil

    def f_score(%__MODULE__{pairs: pairs, top_floor: top_floor}) do
      pairs |> Enum.flat_map(&Map.values/1) |> Enum.map(&(top_floor - &1)) |> Enum.sum()
    end

    def goal(%__MODULE__{pairs: pairs, top_floor: top_floor}) do
      %__MODULE__{
        elevator: top_floor,
        pairs: List.duplicate(%{generator: top_floor, microchip: top_floor}, Enum.count(pairs)),
        top_floor: top_floor
      }
    end

    def neighbors(%__MODULE__{elevator: elevator, pairs: pairs, top_floor: top_floor}) do
      destination_floors = Enum.filter([elevator + 1, elevator - 1], &(&1 in 1..top_floor))

      object_combinations =
        pairs
        |> Enum.with_index()
        |> Enum.flat_map(fn {%{generator: gen_floor, microchip: chip_floor}, index} ->
          [{index, :generator, gen_floor}, {index, :microchip, chip_floor}]
        end)
        |> Enum.filter(fn {_, _, floor} -> floor == elevator end)
        |> combinations()

      destination_floors
      |> Enum.flat_map(fn new_floor ->
        Enum.map(object_combinations, fn combination ->
          new_pairs =
            Enum.reduce(combination, pairs, fn {index, type, _}, pairs ->
              List.update_at(pairs, index, &Map.put(&1, type, new_floor))
            end)

          %__MODULE__{elevator: new_floor, pairs: Enum.sort(new_pairs), top_floor: top_floor}
        end)
      end)
      |> Enum.uniq()
      |> Enum.filter(&valid?/1)
    end

    def valid?(%__MODULE__{pairs: pairs}) do
      floors_with_generators = pairs |> Enum.map(& &1.generator) |> Enum.uniq()

      Enum.all?(floors_with_generators, fn floor ->
        pairs |> Enum.filter(&(&1.microchip == floor)) |> Enum.all?(&(&1.generator == floor))
      end)
    end

    defp combinations([]), do: []
    defp combinations([item]), do: [[item]]

    defp combinations(items) do
      [[hd(items)] | Enum.map(tl(items), &[hd(items), &1]) ++ combinations(tl(items))]
    end
  end

  defmodule Input do
    def parse(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce(%{}, &parse_floor/2)
      |> initialize_node()
    end

    @floor ~r/^The (?<ordinal>\w+) floor contains (?:nothing relevant|(?<objects>.+))\.$/
    @object ~r/(?:a (?<element>\w+)(?:-compatible)? (?<type>generator|microchip))+/
    @ordinals %{"first" => 1, "second" => 2, "third" => 3, "fourth" => 4}

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

    defp parse_objects(""), do: []

    defp parse_objects(objects) do
      objects
      |> String.split(~r/, and|,|and/)
      |> Enum.map(&Regex.named_captures(@object, &1))
      |> Enum.map(fn %{"element" => element, "type" => type} ->
        %{element: String.to_atom(element), type: String.to_atom(type)}
      end)
    end

    defp initialize_node(elements) do
      %Node{
        pairs: elements |> Map.values() |> Enum.sort(),
        top_floor: @ordinals |> Map.values() |> Enum.max()
      }
    end
  end

  defmodule AStar do
    def fewest_steps(%Node{} = start_node) do
      pathfind(%{
        goal: Node.goal(start_node),
        open: MapSet.new([start_node]),
        closed: MapSet.new(),
        g_scores: %{start_node => 0},
        f_scores: %{start_node => Node.f_score(start_node)},
        inverse_f: %{Node.f_score(start_node) => MapSet.new([start_node])}
      })
    end

    defp pathfind(state) do
      current_node = pick_node(state)

      if current_node == state.goal do
        state.g_scores[current_node]
      else
        current_node
        |> Node.neighbors()
        |> Enum.reduce(state, fn next_node, state ->
          g_current = state.g_scores[current_node]
          g_next = state.g_scores[next_node]
          f_next = g_current + Node.f_score(next_node)

          if is_nil(g_next) or g_current < g_next do
            state |> ensure_open(next_node) |> update_scores(next_node, g_current + 1, f_next)
          else
            state
          end
        end)
        |> close(current_node)
        |> pathfind()
      end
    end

    defp pick_node(%{inverse_f: inverse_f}) do
      Stream.iterate(0, &(&1 + 1))
      |> Stream.map(&inverse_f[&1])
      |> Stream.reject(&is_nil/1)
      |> Stream.reject(&(MapSet.size(&1) == 0))
      |> Enum.fetch!(0)
      |> Enum.fetch!(0)
    end

    defp close(state, node) do
      f_score = state.f_scores[node]

      state
      |> update_in([:open], &MapSet.delete(&1, node))
      |> update_in([:closed], &MapSet.put(&1, node))
      |> update_in([:inverse_f, f_score], &if(is_nil(&1), do: MapSet.new(), else: &1))
      |> update_in([:inverse_f, f_score], &MapSet.delete(&1, node))
    end

    defp ensure_open(state, node) do
      state
      |> update_in([:closed], &MapSet.delete(&1, node))
      |> update_in([:open], &MapSet.put(&1, node))
    end

    defp update_scores(state, node, g_score, f_score) do
      old_f_score = state.f_scores[node]

      state
      |> put_in([:g_scores, node], g_score)
      |> put_in([:f_scores, node], f_score)
      |> update_in([:inverse_f, old_f_score], &if(is_nil(&1), do: MapSet.new(), else: &1))
      |> update_in([:inverse_f, old_f_score], &MapSet.delete(&1, node))
      |> update_in([:inverse_f, f_score], &if(is_nil(&1), do: MapSet.new(), else: &1))
      |> update_in([:inverse_f, f_score], &MapSet.put(&1, node))
    end
  end

  def fewest_steps(input) do
    input |> Input.parse() |> AStar.fewest_steps()
  end
end
