defmodule Advent.Day23 do
  alias Advent.BunnyVM, as: VM

  # 🌟 Solve the silver star.
  def decoded_value(input) do
    input |> VM.new() |> VM.set(:a, 7) |> VM.run() |> VM.get(:a)
  end
end
