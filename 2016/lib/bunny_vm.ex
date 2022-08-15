defmodule Advent.BunnyVM do
  @moduledoc "Emulator for devices that run 'assembunny' code."

  defstruct code: {}, ip: 0, a: 0, b: 0, c: 0, d: 0

  @doc "Initialize a VM from puzzle input."
  def new(input) do
    %__MODULE__{code: parse_code(input)}
  end

  def get(%__MODULE__{} = vm, register) when register in ~w(a b c d)a do
    get_in(vm, [Access.key!(register)])
  end

  def set(%__MODULE__{} = vm, register, value) when register in ~w(a b c d)a do
    put_in(vm, [Access.key!(register)], value)
  end

  @doc "Run the VM until it halts (via execution leaving the bounds of the program)."
  def run(%__MODULE__{code: code, ip: ip} = vm) when ip < 0 or ip >= tuple_size(code), do: vm
  def run(%__MODULE__{code: code, ip: ip} = vm), do: vm |> execute(elem(code, ip)) |> run()

  # Move the instruction pointer to a new relative location.
  defp advance_ip(%__MODULE__{ip: ip} = vm, count \\ 1), do: %__MODULE__{vm | ip: ip + count}

  # CPY: write a value to a register.
  defp execute(vm, {:cpy, src, dest}) when is_integer(src) and is_atom(dest),
    do: vm |> set(dest, src) |> advance_ip()

  # CPY with register source.
  defp execute(vm, {:cpy, src, dest}) when is_atom(src) and is_atom(dest),
    do: execute(vm, {:cpy, get(vm, src), dest})

  # INC/DEC: increment or decrement a register's value.
  defp execute(vm, {:inc, dest}) when is_atom(dest),
    do: vm |> update(dest, &(&1 + 1)) |> advance_ip()

  defp execute(vm, {:dec, dest}) when is_atom(dest),
    do: vm |> update(dest, &(&1 - 1)) |> advance_ip()

  # JNZ: if `src` is non-zero, adjust the instruction pointer by `dest`.
  defp execute(vm, {:jnz, 0, _}), do: advance_ip(vm)

  defp execute(vm, {:jnz, src, dest}) when is_integer(src) and is_integer(dest),
    do: advance_ip(vm, dest)

  # JNZ with register source.
  defp execute(vm, {:jnz, src, dest}) when is_atom(src) and is_integer(dest),
    do: execute(vm, {:jnz, get(vm, src), dest})

  defp update(%__MODULE__{} = vm, register, func) when register in ~w(a b c d)a do
    update_in(vm, [Access.key!(register)], func)
  end

  # Parse puzzle input into a more convenient tuple-based representation.
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
        :error -> String.to_existing_atom(token)
      end
    end)
    |> List.to_tuple()
  end
end
