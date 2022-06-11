defmodule Advent.Day15 do
  defmodule Disc do
    # Represents a disc in the kinetic sculpture.
    @enforce_keys [:number, :positions, :start]
    defstruct @enforce_keys
  end

  defmodule Input do
    # Parse the puzzle input into a list of `Disc`.
    def parse(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_disc/1)
    end

    @disc_spec ~r/^Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+).$/

    defp parse_disc(line) do
      [number, positions, start] = Regex.run(@disc_spec, line, capture: :all_but_first)

      %Disc{
        number: String.to_integer(number),
        positions: String.to_integer(positions),
        start: String.to_integer(start)
      }
    end
  end

  # 🌟🌟 Solve either the silver or gold star.
  def ideal_drop_time(input) do
    discs = Input.parse(input)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.find(fn time ->
      Enum.all?(discs, fn %Disc{number: number, positions: positions, start: start} ->
        rem(start + time + number, positions) == 0
      end)
    end)
  end
end
