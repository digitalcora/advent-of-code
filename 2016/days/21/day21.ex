defmodule Advent.Day21 do
  # 🌟 Solve the silver star.
  def scramble(password, rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.reduce(String.to_charlist(password), &apply_rule(&2, &1))
    |> to_string()
  end

  defp apply_rule(
         chars,
         <<"swap position ", x::binary-size(1), " with position ", y::binary-size(1)>>
       ) do
    swap(chars, String.to_integer(x), String.to_integer(y))
  end

  defp apply_rule(chars, <<"swap letter ", a::utf8, " with letter ", b::utf8>>) do
    [x, y] = Enum.map([a, b], fn char -> Enum.find_index(chars, &(&1 == char)) end)
    swap(chars, x, y)
  end

  defp apply_rule(chars, <<"rotate left ", x::binary-size(1), _::binary>>) do
    rotate(chars, -String.to_integer(x))
  end

  defp apply_rule(chars, <<"rotate right ", x::binary-size(1), _::binary>>) do
    rotate(chars, String.to_integer(x))
  end

  defp apply_rule(chars, <<"rotate based on position of letter ", a::utf8>>) do
    index = Enum.find_index(chars, &(&1 == a))
    times = 1 + index + if(index >= 4, do: 1, else: 0)
    rotate(chars, times)
  end

  defp apply_rule(
         chars,
         <<"reverse positions ", x::binary-size(1), " through ", y::binary-size(1)>>
       ) do
    reverse(chars, String.to_integer(x), String.to_integer(y))
  end

  defp apply_rule(
         chars,
         <<"move position ", x::binary-size(1), " to position ", y::binary-size(1)>>
       ) do
    move(chars, String.to_integer(x), String.to_integer(y))
  end

  defp apply_rule(password, _rule), do: password

  # Move the list element at position X to position Y.
  defp move(list, x, y) do
    target = Enum.at(list, x)
    list |> List.delete_at(x) |> List.insert_at(y, target)
  end

  # Reverse the part of a list between positions X and Y, inclusive. X must be less than Y.
  defp reverse(list, x, y) do
    {head, rest} = Enum.split(list, x)
    {middle, tail} = Enum.split(rest, y - x + 1)
    head ++ Enum.reverse(middle) ++ tail
  end

  # Rotate a list by X elements. Negative values rotate to the left, positive values to the right.
  defp rotate(list, x) do
    {head, tail} = Enum.split(list, -rem(x, length(list)))
    tail ++ head
  end

  # Swap the list elements at positions X and Y.
  defp swap(list, x, y), do: do_swap(list, min(x, y), max(x, y))

  defp do_swap(list, x, y) do
    {head, [a | rest]} = Enum.split(list, x)
    {middle, [b | tail]} = Enum.split(rest, y - x - 1)
    head ++ [b] ++ middle ++ [a] ++ tail
  end
end
