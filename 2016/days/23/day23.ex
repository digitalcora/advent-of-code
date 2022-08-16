defmodule Advent.Day23 do
  alias Advent.BunnyVM, as: VM

  # 🌟🌟 Solve either the silver or gold star.
  def decoded_value(program, initial_a) do
    program |> VM.new() |> VM.set(:a, initial_a) |> VM.run() |> VM.get(:a)
  end
end
