defmodule Advent.Day4 do
  defmodule Room do
    # Represents an entry in the list of rooms from the puzzle input.
    @enforce_keys [:name, :sector, :checksum]
    defstruct name: nil, sector: nil, checksum: nil
  end

  # 🌟 Solve the silver star.
  def real_sectors_sum(input) do
    input |> real_rooms() |> Enum.map(& &1.sector) |> Enum.sum()
  end

  # 🌟 Solve the gold star.
  def find_real_sector(input, text) do
    input |> real_rooms() |> Enum.find(&name_contains?(&1, text)) |> Map.get(:sector)
  end

  # Shared convenience function to parse the puzzle input and filter out decoy rooms.
  defp real_rooms(input) do
    input |> parse_input() |> Enum.filter(&valid_room?/1)
  end

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      [_, name, sector, checksum] = Regex.run(~r/^(.+)-(\d+)\[(\w{5})\]$/, line)
      %Room{name: name, sector: String.to_integer(sector), checksum: checksum}
    end)
  end

  # Room entries are only "real" if their checksum is the five most common letters in their name
  # (ignoring dashes), with ties broken by alphabetical order.
  defp valid_room?(room) do
    room.checksum == top_five_letters(room.name)
  end

  defp top_five_letters(string) do
    string
    |> String.replace("-", "")
    |> String.codepoints()
    |> Enum.reduce(%{}, fn char, freqs -> Map.update(freqs, char, 1, &(&1 + 1)) end)
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.slice(0..4)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
  end

  # Find whether a room's decrypted name contains a given string.
  defp name_contains?(room, text) do
    room.name |> decrypt_name(room.sector) |> String.contains?(text)
  end

  # Room names are "decrypted" by rotating each of their letters forward through the alphabet
  # a number of times equal to their sector number.
  defp decrypt_name(name, sector) do
    name |> String.codepoints() |> Enum.map(&shift_letter(&1, sector)) |> Enum.join()
  end

  @alphabet ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

  defp shift_letter(letter, times) when letter in @alphabet do
    old_index = Enum.find_index(@alphabet, &(&1 == letter))
    new_index = rem(old_index + times, length(@alphabet))
    Enum.at(@alphabet, new_index)
  end

  defp shift_letter(other, _), do: other
end
