defmodule Advent.Day5 do
  @nil_password List.duplicate(nil, 8)

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

  defp update_password(password, hash, :in_order) do
    List.replace_at(password, Enum.find_index(password, &(!&1)), String.at(hash, 5))
  end

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
