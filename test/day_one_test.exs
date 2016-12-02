defmodule ElixirAdventOfCodeTest.DayOneTest do
  use ExUnit.Case
  alias AdventOfCode.Solutions.DayOne

  doctest ElixirAdventOfCode

  test "Part(1) - for the given examples results should be as expected" do
    assert DayOne.run("R2, L3").distance == 5
    assert DayOne.run("R2, R2, R2").distance == 2
    assert DayOne.run("R5, L5, R5, R3").distance == 12
  end

  test "Part(2) - for the given examples results should be as expected" do
    assert DayOne.run("R8, R4, R4, R8").visited_twice_distance == 4
  end
end
