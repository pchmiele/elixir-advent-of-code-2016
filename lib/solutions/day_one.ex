defmodule AdventOfCode.Solutions.DayOne do
  @input "L5, R1, L5, L1, R5, R1, R1, L4, L1, L3, R2, R4, L4, L1, L1, R2, R4, R3, L1, R4, L4, L5, L4, R4, L5, R1, R5, L2, R1, R3, L2, L4, L4, R1, L192, R5, R1, R4, L5, L4, R5, L1, L1, R48, R5, R5, L2, R4, R4, R1, R3, L1, L4, L5, R1, L4, L2, L5, R5, L2, R74, R4, L1, R188, R5, L4, L2, R5, R2, L4, R4, R3, R3, R2, R1, L3, L2, L5, L5, L2, L1, R1, R5, R4, L3, R5, L1, L3, R4, L1, L3, L2, R1, R3, R2, R5, L3, L1, L1, R5, L4, L5, R5, R2, L5, R2, L1, L5, L3, L5, L5, L1, R1, L4, L3, L1, R2, R5, L1, L3, R4, R5, L4, L1, R5, L1, R5, R5, R5, R2, R1, R2, L5, L5, L5, R4, L5, L4, L4, R5, L2, R1, R5, L1, L5, R4, L3, R4, L2, R3, R3, R3, L2, L2, L2, L1, L4, R3, L4, L2, R2, R5, L1, R2"

  defmodule Position do
    defstruct x: 0, y: 0, direction: :none, visited: MapSet.new([]), visited_twice_distance: 0

    def move(:turn_left, distance, position) do
      case position.direction do
        :east -> up(position, distance)
        :north -> left(position, distance)
        :west -> down(position, distance)
        :south -> right(position, distance)
        :none -> left(position, distance)
      end
    end

    def move(:turn_right, distance, position) do
      case position.direction do
        :east -> down(position, distance)
        :south -> left(position, distance)
        :west -> up(position, distance)
        :north -> right(position, distance)
        :none -> right(position, distance)
      end
    end

    defp visited_positions_horizontal(start, ending, y) do
      start..ending |> Enum.map(fn(x) -> %{x: x, y: y} end) |> MapSet.new  
    end

    defp visited_positions_vertical(start, ending, x) do
     start..ending |> Enum.map(fn(y) -> %{x: x, y: y} end) |> MapSet.new
    end

    defp check_visited(visited, new_visited, visited_twice_distance) do
      intersection = MapSet.intersection(visited, new_visited)
      if intersection |> MapSet.size > 0 and visited_twice_distance == 0 do
        new_visited_twice_position = MapSet.to_list(intersection) |> List.first 
        new_visited_twice_distance = distance(new_visited_twice_position)
        {MapSet.union(visited, new_visited), new_visited_twice_distance}
      else
        {MapSet.union(visited, new_visited), visited_twice_distance}
      end
    end 

    defp up(position, distance) do 
      visited_positions = visited_positions_vertical(position.y, position.y + distance - 1, position.x)
      {new_visited, new_visited_twice_distance} = check_visited(position.visited, visited_positions, position.visited_twice_distance)
      %{position | y: position.y + distance, direction: :north, visited: new_visited, visited_twice_distance: new_visited_twice_distance}
    end

    defp down(position, distance) do 
      visited_positions = visited_positions_vertical(position.y, position.y - distance + 1, position.x)
      {new_visited, new_visited_twice_distance} = check_visited(position.visited, visited_positions, position.visited_twice_distance)
      %{position | y: position.y - distance, direction: :south, visited: new_visited, visited_twice_distance: new_visited_twice_distance}
    end

    defp left(position, distance) do
      visited_positions = visited_positions_horizontal(position.x, position.x - distance + 1, position.y)
      {new_visited, new_visited_twice_distance} = check_visited(position.visited, visited_positions, position.visited_twice_distance)
      %{position | x: position.x - distance, direction: :west, visited: new_visited, visited_twice_distance: new_visited_twice_distance}
    end

    defp right(position, distance) do
      visited_positions = visited_positions_horizontal(position.x, position.x + distance - 1, position.y) 
      {new_visited, new_visited_twice_distance} = check_visited(position.visited, visited_positions, position.visited_twice_distance)
      %{position | x: position.x + distance, direction: :east, visited: new_visited, visited_twice_distance: new_visited_twice_distance}
    end

    def distance(position) do
      abs(position.x) + abs(position.y)
    end
  end

  alias Position

  defp parse_input(input) do
    input
    |> String.trim
    |> String.split(", ", trim: true)
  end

  defp parse_instruction(instruction) do
    direction = case String.at(instruction, 0) do 
      "L" -> :turn_left
      "R" -> :turn_right
    end 

    value = String.slice(instruction, 1, String.length(instruction) - 1)
    {direction, String.to_integer(value)}
  end

  def run(input \\ @input) do
    result = parse_input(input)
    |> Enum.map(&parse_instruction/1)
    |> Enum.to_list
    |> List.foldl(%Position{}, fn(x, acc) -> Position.move(elem(x, 0) , elem(x,1), acc) end)

    %{distance: Position.distance(result), visited_twice_distance: result.visited_twice_distance}
  end

end
