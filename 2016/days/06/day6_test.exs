defmodule Advent.Day6Test do
  use ExUnit.Case
  alias Advent.Day6

  test "decodes a message hidden in the most common letter of each column" do
    assert Day6.decode(test_message()) == "easter"
  end

  test "decodes a message hidden in the least common letter of each column" do
    assert Day6.decode(test_message(), :least_common) == "advent"
  end

  defp test_message do
    """
      eedadn
      drvtee
      eandsr
      raavrd
      atevrs
      tsrnev
      sdttsa
      rasrtv
      nssdts
      ntnada
      svetve
      tesnvt
      vntsnd
      vrdear
      dvrsen
      enarar
    """
  end
end
