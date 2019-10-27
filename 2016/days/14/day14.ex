defmodule Advent.Day14 do
  def key_index(salt, key_number, rounds \\ 1) do
    cache = :ets.new(:hashes, [:private, :set])

    Stream.iterate(0, &(&1 + 1))
    |> Stream.filter(fn index ->
      hash = hash(salt, index, cache, rounds)

      case Regex.run(~r/(.)\1\1/, hash, capture: :all_but_first) do
        nil ->
          false

        [digit] ->
          Enum.any?((index + 1)..(index + 1000), fn ahead_index ->
            hash(salt, ahead_index, cache, rounds) =~ ~r/(#{digit})\1\1\1\1/
          end)
      end
    end)
    |> Enum.at(key_number - 1)
  end

  defp hash(salt, index, cache, rounds) do
    case :ets.lookup(cache, index) do
      [{_, hash}] ->
        hash

      [] ->
        hash =
          Enum.reduce(1..rounds, salt <> to_string(index), fn _, string ->
            :crypto.hash(:md5, string) |> Base.encode16() |> String.downcase()
          end)

        :ets.insert(cache, {index, hash})
        hash
    end
  end
end
