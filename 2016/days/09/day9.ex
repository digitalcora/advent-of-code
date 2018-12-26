defmodule Advent.Day9 do
  def unpacked_size(input, version \\ 1)

  def unpacked_size("(" <> rest, version) do
    [marker, rest] = String.split(rest, ")", parts: 2)
    {chars, repeats} = parse_marker(marker)
    {packed, rest} = String.split_at(rest, chars)

    case version do
      1 -> chars * repeats + unpacked_size(rest, version)
      2 -> unpacked_size(packed, version) * repeats + unpacked_size(rest, version)
    end
  end

  def unpacked_size("", _version), do: 0
  def unpacked_size(<<_::utf8>> <> rest, version), do: 1 + unpacked_size(rest, version)

  defp parse_marker(marker) do
    [_, chars, repeats] = Regex.run(~r/(\d+)x(\d+)/, marker)
    {String.to_integer(chars), String.to_integer(repeats)}
  end
end
