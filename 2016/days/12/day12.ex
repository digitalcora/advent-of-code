defmodule Advent.Day12 do
  alias Advent.BunnyVM, as: VM

  # 🌟🌟 Solve either the silver or gold star.
  def final_value_in_a(input, initial_c \\ 0) do
    input |> VM.new() |> VM.set(:c, initial_c) |> VM.run() |> VM.get(:a)
  end
end
