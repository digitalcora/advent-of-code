defmodule Advent.Day5 do
  # Passwords are always 8 characters, and characters may be discovered out of order. `nil` is a
  # character we don't know yet.
  @nil_password List.duplicate(nil, 8)

  # 🌟🌟 Solve either the silver or gold star.
  def crack_password(door_id, algorithm \\ :in_order) do
    door_id
    |> interesting_hashes()
    |> Enum.reduce_while(@nil_password, fn hash, password ->
      with password <- update_password(password, hash, algorithm) do
        if Enum.all?(password), do: {:halt, password}, else: {:cont, password}
      end
    end)
    |> Enum.join()
    |> String.downcase()
  end

  # Produce the stream of hashes that determine the password for a given door ID.
  defp interesting_hashes(door_id) do
    Stream.unfold(-1, fn last_interesting_index ->
      Stream.iterate(last_interesting_index + 1, &(&1 + 1))
      |> Stream.map(fn index -> {hash(door_id, index), index} end)
      |> Enum.find(fn {hash, _} -> String.starts_with?(hash, "00000") end)
    end)
  end

  defp hash(door_id, index) do
    :crypto.hash(:md5, door_id <> to_string(index)) |> Base.encode16()
  end

  # For the in-order algorithm, the next unknown character of the password is filled in with the
  # 6th character of the hash.
  defp update_password(password, hash, :in_order) do
    List.replace_at(password, Enum.find_index(password, &(!&1)), String.at(hash, 5))
  end

  # For the War Games algorithm, if the 6th character of the hash corresponds to a valid character
  # index in the password that is not known yet, that position is filled in with the 7th character
  # of the hash. Otherwise this hash is a "dud" and the password is not updated.
  defp update_password(password, hash, :war_games) do
    case hash |> String.at(5) |> String.to_integer(16) do
      index when index in 0..7 ->
        case Enum.at(password, index) do
          nil -> List.replace_at(password, index, String.at(hash, 6))
          _ -> password
        end

      _ ->
        password
    end
  end
end
