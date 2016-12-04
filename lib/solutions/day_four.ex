defmodule AdventOfCode.Solutions.DayFour do
  @regex ~r/(?<encrypted_name>([a-z]*-)*)(?<room>[0-9]*)(?<checksum>\[[a-z]*])/
  @input "lib/resources/day_four.txt"
  @helper "abcdefghijklmnopqrstuvwxyz"

  defp letter_occurences_count(input) do
    input
    |> String.replace("-", "")
    |> String.replace(" ", "")
    |> String.graphemes 
    |> Enum.reduce(%{}, fn(letter, acc) ->
      count = Map.get(acc, letter) || 0
      Map.put(acc, letter, count+1)
    end)
  end

  defp decrypt(input) do
    letter_occurences_count(input)
    |> Map.to_list
    |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
    |> Enum.take(5)
    |> Enum.map(&(elem(&1, 0)))
    |> List.to_string
  end

  defp is_valid?(encrypted_name, checksum) do
    decrypt(encrypted_name) == checksum
  end

  defp read_input_file() do
    File.read!(@input)
    |> String.split("\n")
  end

  def part1(input) do
    input
    |> Enum.map(&(Regex.named_captures(@regex, &1)))
    |> Enum.filter(fn(x) -> 
      is_valid?(x["encrypted_name"], x["checksum"] |> String.replace(~r/\[*\]*/, "")) 
    end)
    |> Enum.map(fn(x) -> 
      x["room"] |> String.to_integer end)
    |> Enum.sum
  end

  def decrypt_name(name, number_of_rotations) do
    letters = @helper |> String.graphemes
    name
    |> String.replace("-", " ") 
    |> String.graphemes
    |> Enum.map(fn(x) -> 
      if (x == " ") do 
        x
      else 
        current_letter_index = letters |> Enum.find_index(&(&1 == x))
        new_index = rem(current_letter_index + number_of_rotations, 26)
        letters |> Enum.at(new_index)
      end
    end)
    |> Enum.join()
    |> String.trim()
  end

  def run1() do
    read_input_file() 
    |> part1
  end

  def run2() do
    result = read_input_file() 
    |> Enum.map(&(Regex.named_captures(@regex, &1)))
    |> Enum.map(fn(x) -> 
      %{name: decrypt_name(x["encrypted_name"], String.to_integer(x["room"])), room: x["room"]}
    end)
    |> Enum.filter(fn(x) -> 
      String.contains?(x.name, "north")
    end)
    |> List.first
    result.room
  end

end
