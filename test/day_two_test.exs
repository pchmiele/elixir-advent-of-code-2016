defmodule ElixirAdventOfCodeTest.DayTwoTest do
  use ExUnit.Case
  alias AdventOfCode.Solutions.DayTwo

  doctest ElixirAdventOfCode
  @test_data [
    "ULL",
    "RRDDD",
    "LURDL",
    "UUUUD"
  ]
  
  test "Part(1) - for the given examples results should be as expected" do  
    assert DayTwo.run1( @test_data) == "1985"
  end

  test "Part(2) - for the given examples results should be as expected" do
    assert DayTwo.run2( @test_data) == "5DB3"
  end
end
