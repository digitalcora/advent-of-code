defmodule Advent.Day10 do
  # 🌟 Solve the silver star.
  def bot_comparing(input, value_a, value_b) do
    input |> parse_input() |> resolve_values() |> bot_id_comparing(value_a, value_b)
  end

  # 🌟 Solve the gold star.
  def output_product(input, output_ids) do
    input |> parse_input() |> resolve_values() |> output_values(output_ids) |> Enum.reduce(&*/2)
  end

  # Construct a directed graph from the puzzle input. Vertices represent inputs, outputs, and
  # bots; edges indicate the flow of data. Edges emanating from bots are labeled `:low` or `:high`
  # to indicate where the low/high values will be sent once the bot has inputs to compare.
  defp parse_input(input) do
    graph = :digraph.new([:acyclic, :private])
    input_lines = input |> String.trim() |> String.split("\n")
    Enum.each(input_lines, &load_instruction(graph, &1))
    graph
  end

  @instruction ~r/^
    (value)\ (\d+)\ goes\ to\ bot\ (\d+)
    |(bot)\ (\d+)\ gives\ low\ to\ (bot|output)\ (\d+)\ and\ high\ to\ (bot|output)\ (\d+)
  $/x

  # Parse a line of the puzzle input and add the discovered information to the graph.
  defp load_instruction(graph, input_line) do
    case Regex.run(@instruction, input_line) |> tl() |> Enum.reject(&(&1 == "")) do
      ["value", value, bot_id] ->
        add_bot_with_input(graph, String.to_integer(bot_id), String.to_integer(value))

      ["bot", bot_id, low_type, low_id, high_type, high_id] ->
        add_bot_with_output(
          graph,
          String.to_integer(bot_id),
          :low,
          String.to_atom(low_type),
          String.to_integer(low_id)
        )

        add_bot_with_output(
          graph,
          String.to_integer(bot_id),
          :high,
          String.to_atom(high_type),
          String.to_integer(high_id)
        )
    end
  end

  # "value <number> goes to bot <id>"
  defp add_bot_with_input(graph, bot_id, value) do
    bot = :digraph.add_vertex(graph, {:bot, bot_id})
    input = :digraph.add_vertex(graph, {:input, value})
    [_ | _] = :digraph.add_edge(graph, input, bot)
    graph
  end

  # "bot <id> gives <low/high> to <target>"
  defp add_bot_with_output(graph, bot_id, output_label, output_type, output_id) do
    bot = :digraph.add_vertex(graph, {:bot, bot_id})
    target = :digraph.add_vertex(graph, {output_type, output_id})
    [_ | _] = :digraph.add_edge(graph, bot, target, output_label)
    graph
  end

  # Determine the flow of values through the completed graph, relabeling edges with the actual
  # value that is sent along the edge. To ensure we always encounter the "origin" of any given
  # edge before its "destination", we resolve vertices in topological order (`topsort`).
  defp resolve_values(graph) do
    graph
    |> :digraph_utils.topsort()
    |> Enum.each(fn
      {:input, value} = input ->
        [out_edge] = :digraph.out_edges(graph, input)
        {_, _, target_bot, _} = :digraph.edge(graph, out_edge)
        :digraph.add_edge(graph, out_edge, input, target_bot, value)

      {:bot, _} = bot ->
        inputs = graph |> :digraph.in_edges(bot) |> Enum.map(&:digraph.edge(graph, &1))
        outputs = graph |> :digraph.out_edges(bot) |> Enum.map(&:digraph.edge(graph, &1))
        [{_, _, _, value_a}, {_, _, _, value_b}] = inputs
        {low_output, _, low_target, _} = Enum.find(outputs, &(elem(&1, 3) == :low))
        {high_output, _, high_target, _} = Enum.find(outputs, &(elem(&1, 3) == :high))
        :digraph.add_edge(graph, low_output, bot, low_target, min(value_a, value_b))
        :digraph.add_edge(graph, high_output, bot, high_target, max(value_a, value_b))

      {:output, _} ->
        nil
    end)

    graph
  end

  # In the "resolved" graph, find the ID of the bot that compares two given values. We do so by
  # finding edges labeled with the two values, finding the set of bots pointed to by those edges,
  # then intersecting the two sets.
  defp bot_id_comparing(graph, value_a, value_b) do
    edges = graph |> :digraph.edges() |> Enum.map(&:digraph.edge(graph, &1))

    [bots_handling_a, bots_handling_b] =
      Enum.map([value_a, value_b], fn value ->
        Enum.reduce(edges, MapSet.new(), fn
          {_, _, bot, ^value}, bots -> MapSet.put(bots, bot)
          _, bots -> bots
        end)
      end)

    [{:bot, id}] = MapSet.intersection(bots_handling_a, bots_handling_b) |> MapSet.to_list()
    id
  end

  # In the "resolved" graph, find the values received by a given list of outputs.
  defp output_values(graph, output_ids) do
    Enum.map(output_ids, fn output_id ->
      [edge] = :digraph.in_edges(graph, {:output, output_id})
      {_, _, _, value} = :digraph.edge(graph, edge)
      value
    end)
  end
end
