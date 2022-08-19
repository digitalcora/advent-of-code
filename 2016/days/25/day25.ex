defmodule Advent.Day25 do
  alias Advent.BunnyVM, as: VM

  # 🌟 Solve the silver star.
  def clock_signal_key(program) do
    vm = VM.new(program)
    Stream.iterate(0, &(&1 + 1)) |> Enum.find(&outputs_clock_signal?(vm, &1))
  end

  defp outputs_clock_signal?(%VM{} = vm, initial_a) when is_integer(initial_a) do
    first_out_vm = vm |> VM.set(:a, initial_a) |> VM.out_step()

    case VM.output(first_out_vm) do
      # The first output value must be 0.
      [0] -> outputs_clock_signal?(first_out_vm, VM.state(first_out_vm))
      _ -> false
    end
  end

  defp outputs_clock_signal?(%VM{} = current_vm, %VM{} = zero_state) do
    next_vm = current_vm |> VM.out_step() |> VM.out_step()

    case VM.output(next_vm) do
      # The next two output values must be 1 followed by 0.
      [0, 1 | _] ->
        if VM.state(next_vm) == zero_state do
          # The VM just output a 0, and is in an identical state to the first time it output a 0,
          # so it will continue to output the clock signal forever.
          true
        else
          # State is not identical, but so far we have output a valid clock signal, so keep going.
          outputs_clock_signal?(next_vm, zero_state)
        end

      _ ->
        false
    end
  end
end
