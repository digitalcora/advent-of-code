defmodule Advent.Day9 do
  # 🌟🌟 Solve either the silver or gold star.
  def unpacked_size(input, version \\ 1)

  # Find the unpacked size of a character sequence starting with a compression marker.
  def unpacked_size("(" <> rest, version) do
    [marker, rest] = String.split(rest, ")", parts: 2)
    {chars, repeats} = parse_marker(marker)
    {packed, rest} = String.split_at(rest, chars)

    # In version 2 of the spec, unpacked sequences are themselves unpacked, recursively.
    case version do
      1 -> chars * repeats + unpacked_size(rest, version)
      2 -> unpacked_size(packed, version) * repeats + unpacked_size(rest, version)
    end
  end

  # The size of character sequences not starting with a compression marker is trivial.
  def unpacked_size("", _version), do: 0
  def unpacked_size(<<_::utf8>> <> rest, version), do: 1 + unpacked_size(rest, version)

  # Compression markers are `(AxB)`, A = the sequence length and B = the repeat count.
  defp parse_marker(marker) do
    [_, chars, repeats] = Regex.run(~r/(\d+)x(\d+)/, marker)
    {String.to_integer(chars), String.to_integer(repeats)}
  end
end
