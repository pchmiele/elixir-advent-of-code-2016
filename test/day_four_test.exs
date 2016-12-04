defmodule ElixirAdventOfCodeTest.DayFourTest do
  use ExUnit.Case
  alias AdventOfCode.Solutions.DayFour

  doctest ElixirAdventOfCode

  test "Part(1) - for the given examples results should be as expected" do
    input = [
      "aaaaa-bbb-z-y-x-123[abxyz]",
      "a-b-c-d-e-f-g-h-987[abcde]",
      "not-a-real-room-404[oarel]",
      "totally-real-room-200[decoy]"
    ]

    assert DayFour.part1(input) == 1514
  end

  test "Part(2) - for the given examples results should be as expected" do
    assert DayFour.decrypt_name("qzmt-zixmtkozy-ivhz", 343) == "very encrypted name"
  end
end


