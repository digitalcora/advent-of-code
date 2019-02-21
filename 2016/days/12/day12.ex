defmodule Advent.Day12 do
  defmodule Machine do
    # A device that runs "assembunny" code. It has a read-only program (`code`) and four integer
    # registers, `a` thru `d`. The instruction pointer `ip` stores the current instruction index.
    defstruct code: {}, ip: 0, a: 0, b: 0, c: 0, d: 0

    # Initializes a `Machine` from puzzle input.
    def new(input) do
      %__MODULE__{code: parse_code(input)}
    end

    def get(%__MODULE__{} = machine, register) do
      get_in(machine, [Access.key!(register)])
    end

    def set(%__MODULE__{} = machine, register, value) do
      put_in(machine, [Access.key!(register)], value)
    end

    # If the instruction pointer ends up outside the bounds of the program, execution ends.
    def run(%__MODULE__{code: code, ip: ip} = machine) when ip < 0 or ip >= tuple_size(code) do
      machine
    end

    def run(%__MODULE__{code: code, ip: ip} = machine) do
      machine |> execute(elem(code, ip)) |> run()
    end

    # CPY: write a value to a register.
    defp execute(machine, {:cpy, src, dest}) when is_integer(src) do
      machine |> set(dest, src) |> advance_ip()
    end

    # CPY with register source.
    defp execute(machine, {:cpy, src, dest}) do
      execute(machine, {:cpy, get(machine, src), dest})
    end

    # INC/DEC: increment or decrement a register's value.
    defp execute(machine, {:inc, dest}), do: machine |> update(dest, &(&1 + 1)) |> advance_ip()
    defp execute(machine, {:dec, dest}), do: machine |> update(dest, &(&1 - 1)) |> advance_ip()

    # JNZ: if `src` is non-zero, adjust the instruction pointer by `dest`.
    defp execute(machine, {:jnz, 0, _}), do: advance_ip(machine)
    defp execute(machine, {:jnz, src, dest}) when is_integer(src), do: advance_ip(machine, dest)

    # JNZ with register source.
    defp execute(machine, {:jnz, src, dest}) do
      execute(machine, {:jnz, get(machine, src), dest})
    end

    defp advance_ip(%{ip: ip} = machine, count \\ 1) do
      %__MODULE__{machine | ip: ip + count}
    end

    defp update(%__MODULE__{} = machine, register, func) do
      update_in(machine, [Access.key!(register)], func)
    end

    # Parse the puzzle input into a convenient tuple-based internal representation.
    defp parse_code(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(&parse_tokens/1)
      |> List.to_tuple()
    end

    defp parse_tokens(tokens) do
      tokens
      |> Enum.map(fn token ->
        case Integer.parse(token) do
          {integer, ""} -> integer
          :error -> String.to_atom(token)
        end
      end)
      |> List.to_tuple()
    end
  end

  # 🌟🌟 Solve either the silver or gold star.
  def final_value_in_a(input, initial_c \\ 0) do
    input |> Machine.new() |> Machine.set(:c, initial_c) |> Machine.run() |> Machine.get(:a)
  end
end
