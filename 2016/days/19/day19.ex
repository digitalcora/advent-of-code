defmodule Advent.Day19 do
  # 🌟🌟 Solve either the silver or gold star.
  def winning_elf(count, :next), do: count |> init_elves() |> play_next()
  def winning_elf(count, :across), do: count |> init_elves() |> play_across()

  # We represent the elves as a fixed-size array of booleans, indicating whether the elf with the
  # corresponding index (+1) is still in the game. This primarily benefits the "across" game, as
  # our approach there requires constant-time random access and updates (finding the next player
  # approaches linear time as the array becomes more "sparse", but this doesn't matter much at
  # the scale of the official puzzle inputs). Though there are more efficient ways to simulate the
  # "next" game, this approach turns out to work fine there too.
  defp init_elves(count), do: :array.new(count, default: true)

  # "NEXT": The current elf eliminates the next elf (in turn order) still in the game.

  # The elf in the first position starts the game.
  defp play_next(elves), do: play_next(elves, 0)

  defp play_next(elves, current_index) do
    case next_index(elves, current_index) do
      ^current_index ->
        # The next elf is also the current one, i.e. there is only one elf remaining. They win!
        current_index + 1

      target_index ->
        # The current elf eliminates the next one, then play continues with the next active elf.
        new_elves = :array.set(target_index, false, elves)
        play_next(new_elves, next_index(new_elves, current_index))
    end
  end

  # "ACROSS": The current elf eliminates the elf directly across from them on an evenly-spaced
  # circle consisting of all elves still in the game, rounded in the direction opposite the turn
  # order. We can efficiently locate this elf in our "sparse array" by observing that they are
  # always either one or two positions ahead of the last elf to be eliminated (alternating each
  # turn), and tracking this index in addition to the current elf's index.

  defp play_across(elves) do
    count = :array.size(elves)
    # The "target increment" starts at 2 if the elf count is odd, 1 if even.
    play_across(elves, 0, div(count, 2), rem(count, 2) + 1)
  end

  # The target elf is also the current one, i.e. there is only one elf remaining. They win!
  defp play_across(_elves, index, index, _), do: index + 1

  # The current elf eliminates the current target, then we advance the indexes and continue.
  defp play_across(elves, current_index, target_index, target_increment) do
    new_elves = :array.set(target_index, false, elves)

    play_across(
      new_elves,
      next_index(new_elves, current_index),
      next_index(new_elves, target_index, target_increment),
      if(target_increment == 1, do: 2, else: 1)
    )
  end

  # Finds the array index of the next elf (in turn order) who is still in the game, given a
  # starting index. If the optional `times` argument is given, repeats the process that many
  # times. N.B.: Loops infinitely if there are somehow zero elves in the game.
  defp next_index(elves, index, times \\ 1) do
    size = :array.size(elves)
    Enum.reduce(1..times, index, fn _, index -> do_next_index(elves, index, size) end)
  end

  defp do_next_index(elves, index, size) when index + 1 >= size,
    do: do_next_index(elves, -1, size)

  defp do_next_index(elves, index, size) do
    case :array.get(index + 1, elves) do
      true -> index + 1
      false -> do_next_index(elves, index + 1, size)
    end
  end
end
