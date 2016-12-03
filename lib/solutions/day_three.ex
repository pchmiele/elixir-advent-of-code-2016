defmodule AdventOfCode.Solutions.DayThree do
  alias AdventOfCode.Resources.DayThreeResources

  defmodule Triangle do
    def is_valid?(sides) do
      longest_side = sides |> Enum.max
      sum = sides |> Enum.sum

      sum - longest_side > longest_side
    end
  end

  alias Triangle

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, " ", trim: true)))
    |> Enum.map(fn(x) -> x |> Enum.map(fn(y) -> String.to_integer(y) end) end)
    |> Enum.filter(fn(x) -> x |> Enum.count > 0 end)
  end

  def run1(input \\DayThreeResources.input()) do
    parse_input(input)
    |> Enum.count(&Triangle.is_valid?/1)
  end

  def run2(input \\DayThreeResources.input()) do
    parse_input(input)
    |> Enum.reduce([[],[],[]], fn
      [a, b, c], [l1, l2, l3] -> 
        [[a | l1], [b | l2], [c | l3]] 
    end)
    |> Enum.concat
    |> Enum.chunk(3)
    |> Enum.count(&Triangle.is_valid?/1)

  end
end
