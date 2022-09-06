defmodule Advent.BunnyVM do
  @moduledoc "Emulator for devices that run 'assembunny' code."

  # `code` is the original program in a parsed tuple-based form, e.g. `{:cpy, 0, :a}`.
  # The instruction pointer `ip` holds the index in the `code` of the next instruction.
  # `out` is a record of output values, most recent first.
  #
  # `patches` is a mechanism for applying "compiler optimizations", while retaining the original
  # code to support self-modifying programs. It maps indices in `code` to a list of instructions
  # that should be executed *instead of* the corresponding one. Instructions within the patch
  # advance or modify `ip` as normal, so execution of the original code may not resume at the
  # instruction immediately following the patched one.
  defstruct code: {}, ip: 0, patches: %{}, a: 0, b: 0, c: 0, d: 0, out: []

  # The VM halts when execution leaves the bounds of the program.
  defguard halted?(vm) when vm.ip < 0 or vm.ip >= tuple_size(vm.code)

  @doc "Initialize a VM from puzzle input."
  def new(input) do
    %__MODULE__{code: parse_code(input)} |> optimize()
  end

  @doc "Get a register value."
  def get(%__MODULE__{} = vm, register) when register in ~w(a b c d)a do
    get_in(vm, [Access.key!(register)])
  end

  @doc "Set a register value."
  def set(%__MODULE__{} = vm, register, value) when register in ~w(a b c d)a do
    put_in(vm, [Access.key!(register)], value)
  end

  @doc "Run the VM until it halts."
  def run(%__MODULE__{} = vm) when halted?(vm), do: vm
  def run(vm), do: vm |> step() |> run()

  @doc "Run the VM until the program outputs a new value, or halts."
  def out_step(%__MODULE__{} = vm) when halted?(vm), do: vm

  def out_step(%__MODULE__{out: out} = vm) do
    %{out: new_out} = new_vm = step(vm)
    if(out == new_out, do: out_step(new_vm), else: new_vm)
  end

  @doc "Get all values output by the program, most recent first."
  def output(%__MODULE__{out: out}), do: out

  @doc "Return a copy of the VM without the record of past outputs, i.e. just the machine state."
  def state(%__MODULE__{} = vm), do: %{vm | out: []}

  @doc """
  Run the VM in debug mode. Requires a list of breakpoints (line numbers), or `:all` to break on
  every line. Before executing a line with a breakpoint, the VM state is dumped to stdout and an
  input is awaited on stdin before continuing. Works best with small programs, as the entire code
  is included in the dump.

  Key:
    `!` indicates a breakpoint (not shown in `:all` mode)
    `>` is the instruction about to be executed
    `*` is a patched instruction (patches are displayed when they are about to be executed)
  """
  def debug(%__MODULE__{} = vm, _breakpoints) when halted?(vm), do: vm
  def debug(vm, breakpoints), do: vm |> dump_await(breakpoints) |> step() |> debug(breakpoints)

  # Run the next instruction. If it is patched, all instructions in the patch are executed.
  defp step(%__MODULE__{code: code, ip: ip, patches: patches} = vm) do
    case Map.get(patches, ip) do
      nil -> vm |> execute(elem(code, ip))
      ops -> ops |> Enum.reduce(vm, &execute(&2, &1))
    end
  end

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

  # OUT: add a value to the output tape.
  defp execute(%__MODULE__{out: out} = vm, {:out, src}),
    do: %{vm | out: [indirect(vm, src) | out]} |> advance_ip()

  # MUL: multiply `src1` by `src2` and add the result to `dest`. All arguments must be registers.
  defp execute(vm, {:mul, src1, src2, dest})
       when is_atom(src1) and is_atom(src2) and is_atom(dest),
       do: vm |> update(dest, &(&1 + get(vm, src1) * get(vm, src2))) |> advance_ip()

  # NOP: do nothing. Added by optimization patches to skip over instructions.
  defp execute(vm, {:nop}), do: advance_ip(vm)

  defp indirect(vm, register) when is_atom(register), do: get(vm, register)
  defp indirect(_vm, constant) when is_integer(constant), do: constant

  # Populate `patches` with any optimizations we can find in the `code`.
  defp optimize(%__MODULE__{code: code} = vm) do
    patches =
      code
      |> Tuple.to_list()
      |> Stream.chunk_every(6, 1)
      |> Stream.with_index()
      |> Enum.reduce(%{}, &add_patch/2)

    %{vm | patches: patches}
  end

  # Optimize a common pattern used to multiply two numbers and add the result to a third.
  defp add_patch(
         {[{:cpy, src, b}, {:inc, a}, {:dec, b}, {:jnz, b, -2}, {:dec, c}, {:jnz, c, -5}], line},
         patches
       )
       when src != a and src != b and src != c and a != b and b != c and a != c do
    Map.put(patches, line, [
      {:cpy, src, b},
      {:mul, b, c, a},
      {:cpy, 0, b},
      {:cpy, 0, c},
      {:nop},
      {:nop}
    ])
  end

  defp add_patch(_, patches), do: patches

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

    # Re-optimize the program since this may now result in different patches.
    %{vm | code: code |> Tuple.delete_at(index) |> Tuple.insert_at(index, new_instruction)}
    |> optimize()
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

  # Dump a human-readable form of the VM state to stdout and await an input on stdin.
  defp dump_await(
         %__MODULE__{code: code, ip: ip, patches: patches, a: a, b: b, c: c, d: d} = vm,
         breakpoints
       ) do
    if breakpoints == :all or ip in breakpoints do
      IO.puts("")

      code
      |> Tuple.to_list()
      |> Stream.with_index()
      |> Enum.each(fn {instruction, index} ->
        if is_list(breakpoints) and index in breakpoints, do: IO.write("!"), else: IO.write(" ")
        if index == ip, do: IO.write(">"), else: IO.write(" ")
        if Map.has_key?(patches, index), do: IO.write("*"), else: IO.write(" ")
        index |> to_string() |> String.pad_leading(2) |> IO.write()
        IO.write(" ")
        instruction |> Tuple.to_list() |> Enum.map(&to_string/1) |> Enum.join(" ") |> IO.puts()
      end)

      IO.puts("")
      IO.puts("A=#{a} B=#{b} C=#{c} D=#{d}")

      if Map.has_key?(patches, ip) do
        IO.puts("")
        IO.puts("PATCH")
        Enum.each(Map.get(patches, ip), &IO.puts("  #{inspect(&1)}"))
      end

      IO.gets("")
    end

    vm
  end
end
