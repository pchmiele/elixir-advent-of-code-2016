defmodule ElixirAdventOfCodeTest.DayThreeTest do
  use ExUnit.Case
  alias AdventOfCode.Solutions.DayThree

  doctest ElixirAdventOfCode

  test "Part(1) - for the given examples results should be as expected" do  
    assert DayThree.run1("5 10 25") == 0
    assert DayThree.run1("5 25 25") == 1
  end
end
