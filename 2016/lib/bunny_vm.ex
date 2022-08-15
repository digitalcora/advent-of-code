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
  defp execute(vm, {:cpy, src, dest}) when is_atom(dest),
    do: vm |> set(dest, indirect(vm, src)) |> advance_ip()

  # Invalid CPY which can be created by a TGL. Does nothing.
  defp execute(vm, {:cpy, _src, _dest}), do: advance_ip(vm)

  # INC/DEC: increment or decrement a register's value.
  defp execute(vm, {:inc, dest}) when is_atom(dest),
    do: vm |> update(dest, &(&1 + 1)) |> advance_ip()

  defp execute(vm, {:dec, dest}) when is_atom(dest),
    do: vm |> update(dest, &(&1 - 1)) |> advance_ip()

  # JNZ: if `src` is non-zero, adjust the instruction pointer by `dest`.
  defp execute(vm, {:jnz, src, dest}) do
    case indirect(vm, src) do
      0 -> advance_ip(vm)
      _ -> advance_ip(vm, indirect(vm, dest))
    end
  end

  # TGL: mutate the instruction `dest` instructions away.
  defp execute(%__MODULE__{ip: ip} = vm, {:tgl, dest}),
    do: vm |> toggle(ip + indirect(vm, dest)) |> advance_ip()

  defp indirect(vm, register) when is_atom(register), do: get(vm, register)
  defp indirect(_vm, constant) when is_integer(constant), do: constant

  # Toggling a location outside the program has no effect.
  defp toggle(%__MODULE__{code: code} = vm, index) when index < 0 or index >= tuple_size(code),
    do: vm

  defp toggle(%__MODULE__{code: code} = vm, index) do
    new_instruction =
      case elem(code, index) do
        {:inc, dest} -> {:dec, dest}
        {_, dest} -> {:inc, dest}
        {:jnz, src, dest} -> {:cpy, src, dest}
        {_, src, dest} -> {:jnz, src, dest}
      end

    %{vm | code: code |> Tuple.delete_at(index) |> Tuple.insert_at(index, new_instruction)}
  end

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
