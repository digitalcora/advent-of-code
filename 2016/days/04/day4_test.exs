defmodule Advent.Day4Test do
  use ExUnit.Case
  alias Advent.Day4

  test "sums the sector IDs of all room entries that have a valid checksum" do
    assert Day4.real_sectors_sum(test_entries()) == 1857
  end

  test "finds the first sector ID among real rooms whose decrypted name contains a string" do
    assert Day4.find_real_sector(test_entries(), "encrypted") == 343
  end

  defp test_entries do
    """
      aaaaa-bbb-z-y-x-123[abxyz]
      a-b-c-d-e-f-g-h-987[abcde]
      qzmt-zixmtkozy-ivhz-255[badrm]
      qzmt-zixmtkozy-ivhz-343[zimth]
      not-a-real-room-404[oarel]
      totally-real-room-200[decoy]
    """
  end
end
