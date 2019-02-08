defmodule Advent.Day7 do
  # 🌟 Solve the silver star.
  def tls_address_count(input) do
    input |> String.split() |> Enum.filter(&supports_tls?/1) |> length()
  end

  # 🌟 Solve the gold star.
  def ssl_address_count(input) do
    input |> String.split() |> Enum.filter(&supports_ssl?/1) |> length()
  end

  # An address supports "TLS" if it contains a 4-character palindrome where the first and second
  # characters are different ("ABBA"), and there are no ABBAs within a "hypernet" (brackets).

  @abba ~r/(.)(?!\1)(.)\2\1/
  @abba_in_hypernet ~r/\[[^\]]*#{Regex.source(@abba)}/

  defp supports_tls?(address) do
    address =~ @abba and not (address =~ @abba_in_hypernet)
  end

  # An address supports "SSL" if any of its "supernets" (sequences outside brackets) contain a
  # 3-character palindrome where the first and second characters are different ("ABA"), and the
  # same palindrome appears in a hypernet with the characters swapped ("BAB").

  @aba ~r/(.)(?!\1)(?=(.)\1)/
  @supernet ~r/(?:^|\])([^\[]*)(?:\[|$)/
  @hypernet ~r/\[([^\]]*)\]/

  defp supports_ssl?(address) do
    supernets = Regex.scan(@supernet, address) |> Enum.map(&hd(tl(&1)))
    hypernets = Regex.scan(@hypernet, address) |> Enum.map(&hd(tl(&1)))

    ab_pairs = supernets |> Enum.flat_map(&Regex.scan(@aba, &1)) |> Enum.map(&tl/1) |> Enum.uniq()

    Enum.any?(hypernets, fn hypernet ->
      Enum.any?(ab_pairs, fn [a, b] ->
        String.contains?(hypernet, "#{b}#{a}#{b}")
      end)
    end)
  end
end
