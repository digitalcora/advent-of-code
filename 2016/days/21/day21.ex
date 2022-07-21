defmodule Advent.Day21 do
  # 🌟 Solve the silver star.
  def scramble(password, rules) do
    rules |> parse_rules() |> apply_rules(password, :forward)
  end

  # 🌟 Solve the gold star.
  def unscramble(password, rules) do
    rules |> parse_rules() |> Enum.reverse() |> apply_rules(password, :reverse)
  end

  defp parse_rules(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_rule/1)
  end

  defp apply_rules(rules, password, direction) do
    rules
    |> Enum.reduce(String.to_charlist(password), fn rule, chars -> rule.(chars, direction) end)
    |> to_string()
  end

  # Exploiting the fact that the official inputs only use single-digit numeric arguments, we can
  # parse all rules with binary pattern-matching.

  defp parse_rule(<<"move position ", x::binary-size(1), " to position ", y::binary-size(1)>>),
    do: &move(&1, String.to_integer(x), String.to_integer(y), &2)

  defp parse_rule(<<"swap position ", x::binary-size(1), " with position ", y::binary-size(1)>>),
    do: &swap(&1, String.to_integer(x), String.to_integer(y), &2)

  defp parse_rule(<<"swap letter ", a::utf8, " with letter ", b::utf8>>),
    do: &swap_elems(&1, a, b, &2)

  defp parse_rule(<<"reverse positions ", x::binary-size(1), " through ", y::binary-size(1)>>),
    do: &reverse(&1, String.to_integer(x), String.to_integer(y), &2)

  defp parse_rule(<<"rotate left ", x::binary-size(1), _::binary>>),
    do: &rotate(&1, -String.to_integer(x), &2)

  defp parse_rule(<<"rotate right ", x::binary-size(1), _::binary>>),
    do: &rotate(&1, String.to_integer(x), &2)

  defp parse_rule(<<"rotate based on position of letter ", a::utf8>>), do: &rotate_elem(&1, a, &2)

  # Move the list element at position X to position Y.
  defp move(list, x, y, :forward) do
    target = Enum.at(list, x)
    list |> List.delete_at(x) |> List.insert_at(y, target)
  end

  defp move(list, x, y, :reverse), do: move(list, y, x, :forward)

  # Reverse the part of a list between positions X and Y, inclusive. X must be less than Y.
  defp reverse(list, x, y, _direction) do
    {head, rest} = Enum.split(list, x)
    {middle, tail} = Enum.split(rest, y - x + 1)
    head ++ Enum.reverse(middle) ++ tail
  end

  # Rotate a list X times. Negative values rotate to the left, positive values to the right.
  defp rotate(list, x, :forward) do
    {head, tail} = Enum.split(list, -rem(x, length(list)))
    tail ++ head
  end

  defp rotate(list, x, :reverse), do: rotate(list, -x, :forward)

  # Rotate a list to the right a number of times equal to the index of element A plus one, or
  # plus two if the index is at least 4.
  defp rotate_elem(list, a, :forward) do
    index = Enum.find_index(list, &(&1 == a))
    times = index + if(index >= 4, do: 2, else: 1)
    rotate(list, times, :forward)
  end

  defp rotate_elem(list, a, :reverse) do
    # Try all possible rotations until we find the one that, when the forward `rotate_elem` is
    # run on it, produces the given list.
    1..(length(list) - 1)
    |> Enum.find_value(fn times ->
      reversed = rotate(list, -times, :forward)
      if(list == rotate_elem(reversed, a, :forward), do: reversed)
    end)
  end

  # Swap the list elements at positions X and Y.
  defp swap(list, x, y, _direction), do: do_swap(list, min(x, y), max(x, y))

  defp do_swap(list, x, y) do
    {head, [a | rest]} = Enum.split(list, x)
    {middle, [b | tail]} = Enum.split(rest, y - x - 1)
    head ++ [b] ++ middle ++ [a] ++ tail
  end

  # Swap the positions of list elements A and B.
  defp swap_elems(list, a, b, direction) do
    [x, y] = Enum.map([a, b], fn elem -> Enum.find_index(list, &(&1 == elem)) end)
    swap(list, x, y, direction)
  end
end
