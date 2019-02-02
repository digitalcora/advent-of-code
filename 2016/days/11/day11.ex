defmodule Advent.Day11 do
  def least_steps(input) do
    input |> parse_input() |> initialize_state() |> shortest_path_length()
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, &parse_floor/2)
  end

  @floor ~r/^The (?<ordinal>\w+) floor contains (?:nothing relevant|(?<objects>.+))\.$/
  @object ~r/(?:a (?<element>\w+)(?:-compatible)? (?<type>generator|microchip))+/
  @ordinals %{"first" => 1, "second" => 2, "third" => 3, "fourth" => 4}
  @top_floor @ordinals |> Map.values() |> Enum.max()

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

  defp initialize_state(elements) do
    %{
      elevator: 1,
      pairs: elements |> Map.values() |> Enum.sort()
    }
  end

  defp shortest_path_length(start_state) do
    pathfind(
      %{
        open: MapSet.new([start_state]),
        closed: MapSet.new(),
        g_score: %{start_state => 0},
        f_score: %{start_state => ideal_distance_to_goal(start_state)},
        inverse_f: %{ideal_distance_to_goal(start_state) => MapSet.new([start_state])}
      },
      goal_state(start_state)
    )
  end

  defp most_promising_state(%{inverse_f: inverse_f}) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&inverse_f[&1])
    |> Stream.reject(&is_nil/1)
    |> Stream.reject(&(MapSet.size(&1) == 0))
    |> Enum.fetch!(0)
    |> Enum.fetch!(0)
  end

  defp pathfind(states, goal_state) do
    current_state = most_promising_state(states)

    if current_state == goal_state do
      states.g_score[current_state]
    else
      current_state
      |> next_states()
      |> Enum.reduce(states, fn next_state, states ->
        g_current = states.g_score[current_state]
        g_next = states.g_score[next_state]
        f_next = g_current + ideal_distance_to_goal(next_state)

        cond do
          next_state in states.open and g_current < g_next ->
            states
            |> put_in([:g_score, next_state], g_current + 1)
            |> update_in([:inverse_f, states.f_score[next_state]], &MapSet.delete(&1, next_state))
            |> update_in([:inverse_f, f_next], &if(is_nil(&1), do: MapSet.new(), else: &1))
            |> update_in([:inverse_f, f_next], &MapSet.put(&1, next_state))
            |> put_in([:f_score, next_state], f_next)

          next_state in states.closed and g_current < g_next ->
            states
            |> update_in([:closed], &MapSet.delete(&1, next_state))
            |> update_in([:open], &MapSet.put(&1, next_state))
            |> put_in([:g_score, next_state], g_current + 1)
            |> put_in([:f_score, next_state], f_next)
            |> update_in([:inverse_f, f_next], &if(is_nil(&1), do: MapSet.new(), else: &1))
            |> update_in([:inverse_f, f_next], &MapSet.put(&1, next_state))

          next_state not in states.open and next_state not in states.closed ->
            states
            |> update_in([:open], &MapSet.put(&1, next_state))
            |> put_in([:g_score, next_state], g_current + 1)
            |> put_in([:f_score, next_state], f_next)
            |> update_in([:inverse_f, f_next], &if(is_nil(&1), do: MapSet.new(), else: &1))
            |> update_in([:inverse_f, f_next], &MapSet.put(&1, next_state))

          true ->
            states
        end
      end)
      |> update_in([:open], &MapSet.delete(&1, current_state))
      |> update_in([:closed], &MapSet.put(&1, current_state))
      |> update_in([:inverse_f, states.f_score[current_state]], &MapSet.delete(&1, current_state))
      |> pathfind(goal_state)
    end
  end

  defp goal_state(%{pairs: pairs}) do
    %{
      elevator: @top_floor,
      pairs: List.duplicate(%{generator: @top_floor, microchip: @top_floor}, Enum.count(pairs))
    }
  end

  defp next_states(%{elevator: elevator, pairs: pairs}) do
    object_combinations =
      pairs
      |> Enum.with_index()
      |> Enum.flat_map(fn {%{generator: gen_floor, microchip: chip_floor}, index} ->
        [{index, :generator, gen_floor}, {index, :microchip, chip_floor}]
      end)
      |> Enum.filter(fn {_, _, floor} -> floor == elevator end)
      |> combinations()

    [elevator + 1, elevator - 1]
    |> Enum.filter(&(&1 in 1..@top_floor))
    |> Enum.flat_map(fn new_elevator ->
      Enum.map(object_combinations, fn combination ->
        new_pairs =
          Enum.reduce(combination, pairs, fn {index, type, _}, pairs ->
            List.update_at(pairs, index, &Map.put(&1, type, new_elevator))
          end)

        %{elevator: new_elevator, pairs: Enum.sort(new_pairs)}
      end)
    end)
    |> Enum.uniq()
    |> Enum.filter(&valid_state?/1)
  end

  defp combinations([]), do: []
  defp combinations([item]), do: [[item]]

  defp combinations(items) do
    [[hd(items)] | Enum.map(tl(items), &[hd(items), &1]) ++ combinations(tl(items))]
  end

  defp valid_state?(%{pairs: pairs}) do
    floors_with_generators = pairs |> Enum.map(& &1.generator) |> Enum.uniq()

    Enum.all?(floors_with_generators, fn floor ->
      pairs |> Enum.filter(&(&1.microchip == floor)) |> Enum.all?(&(&1.generator == floor))
    end)
  end

  defp ideal_distance_to_goal(%{pairs: pairs}) do
    pairs
    |> Enum.flat_map(&Map.values/1)
    |> Enum.map(&(@top_floor - &1))
    |> Enum.sum()
  end
end
