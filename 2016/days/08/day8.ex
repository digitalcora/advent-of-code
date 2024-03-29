defmodule Advent.Day8 do
  # 🌟 Solve the silver star.
  def pixel_count(input, width, height) do
    input
    |> parse_input()
    |> run_instructions(width, height)
    |> count_live_pixels()
  end

  # 🌟 Solve the gold star. Requires human eyeball inspection, does not attempt "OCR".
  def pixel_ascii(input, width, height) do
    input
    |> parse_input()
    |> run_instructions(width, height)
    |> inspect_pixels()
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  @instruction ~r/^
    (rect)\ (\d+)x(\d+)
    |rotate\ (row)\ y=(\d+)\ by\ (\d+)
    |rotate\ (column)\ x=(\d+)\ by\ (\d+)
  $/x

  # Parse a line of the puzzle input into convenient "instruction" tuples.
  defp parse_instruction(line) do
    case Regex.run(@instruction, line) |> tl() |> Enum.reject(&(&1 == "")) do
      ["rect", width, height] -> {:rect, String.to_integer(width), String.to_integer(height)}
      ["row", y, count] -> {:rotate_row, String.to_integer(y), String.to_integer(count)}
      ["column", x, count] -> {:rotate_col, String.to_integer(x), String.to_integer(count)}
    end
  end

  # Execute the given list of instructions on a display of the given width and height. Returns a
  # list of rows of pixels (booleans for whether the pixel is on). All pixels are initially off.
  defp run_instructions(instructions, width, height) do
    display = false |> List.duplicate(width) |> List.duplicate(height)
    Enum.reduce(instructions, display, &run_instruction/2)
  end

  # Run a `rect` instruction. Turns on all pixels within a rectangle at the top-left corner.
  defp run_instruction({:rect, width, height}, display) do
    {target_rows, rest_rows} = Enum.split(display, height)

    updated_rows =
      Enum.map(target_rows, fn row ->
        List.duplicate(true, width) ++ Enum.drop(row, width)
      end)

    updated_rows ++ rest_rows
  end

  # Run a `rotate row` instruction. Rotates the pixels in a row rightward (with wraparound).
  defp run_instruction({:rotate_row, y, count}, display) do
    List.update_at(display, y, &Enum.slide(&1, -count..-1, 0))
  end

  # Run a `rotate column` instruction. Rotates the pixels in a column downward (with wraparound).
  defp run_instruction({:rotate_col, x, count}, display) do
    column = Enum.map(display, fn row -> Enum.at(row, x) end)
    [rotated_column] = run_instruction({:rotate_row, 0, count}, [column])

    display
    |> Enum.zip(rotated_column)
    |> Enum.map(fn {row, pixel} -> List.replace_at(row, x, pixel) end)
  end

  # Return the count of pixels in a display that are on.
  defp count_live_pixels(display) do
    display |> Enum.map(fn row -> Enum.count(row, & &1) end) |> Enum.sum()
  end

  # Dump a display as an ASCII diagram using "#" and "." for on and off pixels.
  defp inspect_pixels(display) do
    display
    |> Enum.map(fn row ->
      Enum.reduce(row, "", fn pixel, output -> output <> if(pixel, do: "#", else: ".") end)
    end)
    |> Enum.join("\n")
  end
end
