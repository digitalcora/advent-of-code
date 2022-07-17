defmodule Advent.Day20 do
  # 🌟 Solve the silver star.
  def lowest_allowed_ip(input) do
    input
    |> parse_input()
    |> Enum.reduce_while(nil, fn
      range, nil ->
        # In the unlikely event the first range does not start at 0, we are done, since 0 is a
        # valid IP. Else, the end of the range becomes our "highest blocked IP" accumulator.
        if(0 < range.first, do: {:halt, 0}, else: {:cont, range.last})

      range, highest_blocked ->
        # If we can go one beyond the current highest blocked IP and not hit the next range, we
        # have found the lowest allowed IP.
        if highest_blocked + 1 < range.first do
          {:halt, highest_blocked + 1}
        else
          {:cont, max(highest_blocked, range.last)}
        end
    end)
  end

  @highest_valid_ip 4_294_967_295

  # 🌟 Solve the gold star.
  def allowed_ip_count(input, highest_valid \\ @highest_valid_ip) do
    {highest_blocked, allowed_count} =
      input
      |> parse_input()
      |> Enum.reduce({-1, 0}, fn range, {highest_blocked, allowed_count} ->
        # Keep track of the highest blocked IP. If there is a positive "gap" between it and the
        # start of the next range, add the size of the gap to our count of allowed IPs.
        {
          max(highest_blocked, range.last),
          allowed_count + max(0, range.first - highest_blocked - 1)
        }
      end)

    # If the blocked ranges do not extend all the way to the highest valid IP, we need to add in
    # that gap as well.
    allowed_count + (highest_valid - highest_blocked)
  end

  # Parse the input into a list of `Range`, sorted by the start of the range.
  defp parse_input(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.map(fn line ->
      [first, last] = line |> String.split("-") |> Enum.map(&String.to_integer/1) |> Enum.sort()
      first..last
    end)
    |> Enum.sort_by(& &1.first)
  end
end
