defmodule Advent.Day7 do
  def tls_address_count(input) do
    input |> String.split() |> Enum.filter(&supports_tls?/1) |> length()
  end

  def ssl_address_count(input) do
    input |> String.split() |> Enum.filter(&supports_ssl?/1) |> length()
  end

  @abba ~r/(.)(?!\1)(.)\2\1/
  @abba_in_brackets ~r/\[[^\]]*#{Regex.source(@abba)}/

  defp supports_tls?(address) do
    address =~ @abba and not (address =~ @abba_in_brackets)
  end

  @aba ~r/(.)(?!\1)(?=(.)\1)/
  @supernet_sequence ~r/(?:^|\])([^\[]*)(?:\[|$)/
  @hypernet_sequence ~r/\[([^\]]*)\]/

  defp supports_ssl?(address) do
    supernets = Regex.scan(@supernet_sequence, address) |> Enum.map(&hd(tl(&1)))
    hypernets = Regex.scan(@hypernet_sequence, address) |> Enum.map(&hd(tl(&1)))

    ab_pairs = supernets |> Enum.flat_map(&Regex.scan(@aba, &1)) |> Enum.map(&tl/1) |> Enum.uniq()

    Enum.any?(hypernets, fn hypernet ->
      Enum.any?(ab_pairs, fn [a, b] ->
        String.contains?(hypernet, "#{b}#{a}#{b}")
      end)
    end)
  end
end
