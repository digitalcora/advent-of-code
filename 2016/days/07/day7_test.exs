defmodule Advent.Day7Test do
  use ExUnit.Case
  alias Advent.Day7

  test "determines how many addresses support Transport-Layer Snooping" do
    assert Day7.tls_address_count(test_tls_addresses()) == 3
  end

  test "determines how many addresses support Super-Secret Listening" do
    assert Day7.ssl_address_count(test_ssl_addresses()) == 3
  end

  defp test_tls_addresses do
    """
    abba[mnop]qrst
    abcd[bddb]xyyx
    aaaa[qwer]tyui
    ioxxoj[asdfgh]zxcvbn
    abcd[fbddbg]xyyx
    abcd[mnop]abba[qwer]
    """
  end

  defp test_ssl_addresses do
    """
    aba[bab]xyz
    xyx[xyx]xyx
    aaa[kek]eke
    zazbz[bzb]cdb
    """
  end
end
