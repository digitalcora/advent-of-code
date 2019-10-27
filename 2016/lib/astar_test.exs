defmodule Advent.AStarTest do
  use ExUnit.Case
  alias Advent.AStar

  defmodule Node do
    defstruct maze: [[" "]], position: {0, 0}, goal: {0, 0}

    def h_score(%__MODULE__{position: {px, py}, goal: {gx, gy}}) do
      abs(px - gx) + abs(py - gy)
    end

    def neighbors(%__MODULE__{maze: maze, position: {x, y}} = node) do
      [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      |> Enum.filter(fn {x, y} -> maze |> Enum.at(y, []) |> Enum.at(x) == " " end)
      |> Enum.map(fn {x, y} -> %__MODULE__{node | position: {x, y}} end)
    end
  end

  test "finds the shortest path through a maze" do
    start = %Node{maze: test_maze(), position: {1, 1}, goal: {5, 14}}

    assert AStar.fewest_steps(start) == 41
  end

  test "returns nil when a path cannot be found" do
    start = %Node{maze: test_maze(), position: {1, 1}, goal: {10, 3}}

    refute AStar.fewest_steps(start)
  end

  defp test_maze do
    """
    ###########
    #   #     #
    # ### # ###
    #     # #
    ####### # #
    #       # #
    # # ### ###
    # #   #   #
    # ####### #
    # #     # #
    # # ### # #
    #   #   # #
    # ### ### #
    #   # #   #
    ##### #####
    """
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
  end
end
