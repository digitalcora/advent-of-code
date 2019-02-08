defmodule Advent.Day2 do
  # Describe the keypads in the puzzle. Keys are represented as `{{X, Y}, D}` where X and Y are
  # the coordinates and D is the digit printed on the key.
  @keypads %{
    square: [
      {{-1, -1}, "1"},
      {{0, -1}, "2"},
      {{1, -1}, "3"},
      {{-1, 0}, "4"},
      {{0, 0}, "5"},
      {{1, 0}, "6"},
      {{-1, 1}, "7"},
      {{0, 1}, "8"},
      {{1, 1}, "9"}
    ],
    diamond: [
      {{2, -2}, "1"},
      {{1, -1}, "2"},
      {{2, -1}, "3"},
      {{3, -1}, "4"},
      {{0, 0}, "5"},
      {{1, 0}, "6"},
      {{2, 0}, "7"},
      {{3, 0}, "8"},
      {{4, 0}, "9"},
      {{1, 1}, "A"},
      {{2, 1}, "B"},
      {{3, 1}, "C"},
      {{2, 2}, "D"}
    ]
  }

  # 🌟🌟 Solve either the silver or gold star.
  def keypad_code(input, keypad_type \\ :square) do
    input |> String.split() |> find_digits(@keypads[keypad_type])
  end

  defp find_digits(sequences, keypad) do
    Enum.reduce(sequences, "", fn sequence, digits ->
      digits <> next_digit(sequence, String.last(digits), keypad)
    end)
  end

  # Given a line of the puzzle input, the last digit of the combination found so far (nil if no
  # digits have been found), and the keypad type, find the next digit of the combination.
  defp next_digit(sequence, last_digit, keypad) do
    current_position = keypad |> position_of(last_digit)
    new_position = sequence |> String.codepoints() |> follow_directions(current_position, keypad)

    keypad |> digit_at(new_position)
  end

  # Given starting coordinates and a list of directions, find the new coordinates after following
  # the directions on a given keypad.
  defp follow_directions(directions, start_at, keypad) do
    Enum.reduce(directions, start_at, fn direction, position ->
      new_position = move(direction, position)
      if keypad |> digit_at?(new_position), do: new_position, else: position
    end)
  end

  defp move("U", {x, y}), do: {x, y - 1}
  defp move("D", {x, y}), do: {x, y + 1}
  defp move("L", {x, y}), do: {x - 1, y}
  defp move("R", {x, y}), do: {x + 1, y}

  defp digit_at?(keypad, position) do
    !is_nil(List.keyfind(keypad, position, 0))
  end

  defp digit_at(keypad, position) do
    keypad |> List.keyfind(position, 0) |> elem(1)
  end

  defp position_of(_, nil), do: {0, 0}

  defp position_of(keypad, digit) do
    keypad |> List.keyfind(digit, 1) |> elem(0)
  end
end
