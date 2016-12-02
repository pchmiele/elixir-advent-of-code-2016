defmodule AdventOfCode.Solutions.DayTwo do
  @input ["DLRRRRLRLDRRRURRURULRLLULUURRRDDLDULDULLUUDLURLURLLDLUUUDUUUULDRDUUDUDDRRLRDDDUDLDLLRUURDRULUULRLRDULULLRLRLRLDRLUULDLDDDDRRLRUUUDDRURRULLLRURLUURULLRLUDDLDRUULDRURULRRRLLLRDLULDRRDDUDLURURLDULDRDRLDDUURRDUDDRDUURDULDUURDUDRDRULDUDUULRRULUUURDUURUDLDURDLRLURUUDRRDLRUDRULRURLDLLDLLRRDRDRLRRRULDRRLDUURLUUDLUUDDLLRULRDUUDURURLUURDRRRUDLRDULRRRLDRDULRUUDDDLRDUULDRLLDRULUULULRDRUUUULULLRLLLRUURUULRRLDDDRULRRRUDURUR",
"RULRUUUDLLUDURDRDDLLRLLUDRUDDRLRRDLDLDRDULDLULURDLUDDDUULURLDRUUURURLLRRDDDUUDRLRLLDLDRDDDRDUDLRDRDLLLDDLDUDDRUDUUDLLLLLDULRLURRRLLURUUULUDRLRLRLURRDRLLLRLLULRLLLDDLRLRDLUUUUUDULULDDULLUDUURDLRUDLRUDLRLLRLDLULRLDUDRURURDLRULDLULULDLLDLDLDLLLUDUDDLRLRRDULLUDRDDLLLDUURDULUDURLLLDRUDDDLRLULDLDRRDDDRDULDDUDRDDULLULRRLRUULRDUDURUDULUDUDURLDRDUUDDRRLRURDRRLRDDDDRUDLUDLDDLRDLUUDLRRURDDLURDLRDLLRDRDLDLDUUUURULUULDDDDLDULUURRRULUDLLLDRULDRURL",
"RRRLRDLLDUURDRRRLURDUULUDURDRRUUDURURRLDLLDRDLRRURDDUDDURLRUUDDULULRUUDRLUUDDLLDDDLRRRDLLLLLLRRURDULDLURRURRDDLDDDUDURRDURRRLUDRRULLRULDRLULRULDDRLLRDLRDUURULURLUURLRRULDULULUULDUDLRLDRDDRRRUUULULDUURLRLLURRLURDUUDDDRUULDLLLDRUURLRRLLDDUDRDLDDDULDRDDDUDRRLLLULURDUDLLUUURRLDULURURDDLUDLLRLDRULULURDLDRLURDLRRDRRUULLULDLURRDDUDRDDDLDUDLDRRUDRULDLDULRLLRRRRDDRLUURRRRDDLLRUURRLRURULDDULRLULRURRUULDUUDURDRRLRLUDRULDRUULUUDRDURDURRLULDDDULDDLRDURRUUUUUDDRRDLRDULUUDDL",
"DRRLLRRLULDDULRDDLRLDRURDDUDULURRDLUUULURRRLLRLULURLLRLLDLLUDDLLRDRURRDLDDURRURDRDDUDDDLLRLDLDLDDDDRRRRUDUDLRDUDDURLLRURRDUDLRLLUDDRLDUUDDLLLUDRRRLLDDULUDDRLLUDDULLDDLRLDLRURRLUDDLULULDLUURDLLUDUDRRRRDULUDLRRLRUDDUUDRRLLRUUDRRLDDLRRRUDRRDRRDDUDLULLURRUURLLLDRDDLUDDDUDDRURURDLRUULLRDRUUDRDUDRLULLDURUUULDDLDRDRUDRUDUULDDRLRDRRDRRRRLRLRUULDDUUDDLLLLRRRDUDLRDLDUDDUURLUDURLDRRRDRUDUDRLDLRLDRDDLUDRURLRDRDLDUDDDLRLULLUULURLDDDULDUDDDLDRLDLURULLUDLLDRULDLLLDUL",
"LDULURUULLUDLDDRLLDURRULRLURLLURLRRLRDLDDRUURULLRUURUURRUDDDLRRLDDLULDURLLRDURDLLLURLDRULLURLRLDRDRULURDULDLLDUULLLDUDULDURLUDRULRUUUUUUDUUDDDLLURDLDLRLRDLULRDRULUUDRLULLURLRLDURDRRDUDDDURLLUUDRRURUDLDUDRLRLDRLLLLDLLLURRUDDURLDDRULLRRRRDUULDLUDLDRDUUURLDLLLDLRLRRLDDULLRURRRULDLURLURRRRULUURLLUULRURDURURLRRDULLDULLUDURDUDRLUULULDRRDLLDRDRRULLLDDDRDUDLRDLRDDURRLDUDLLRUDRRRUDRURURRRRDRDDRULRRLLDDRRRLDLULRLRRRUDUDULRDLUDRULRRRRLUULRULRLLRLLURDLUURDULRLDLRLURDUURUULUUDRLLUDRULULULLLLRLDLLLDDDLUULUDLLLDDULRDRULURDLLRRDRLUDRD"]

  @model1 [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]

  @model2 [
    [0, 0, 1, 0, 0],
    [0, 2, 3, 4, 0],
    [5, 6, 7, 8, 9],
    [0, "A","B","C", 0],
    [0, 0, "D", 0, 0]
  ]

  defmodule Keypad do
    defstruct position: %{x: 1, y: 1}, code: "", model: []

    def find_code([], state) do
      %{state | code: state.code <> Keypad.code_at(state.model, state.position)}
    end

    def find_code([first_instruction|rest_of_instructions], state) do
      case first_instruction do
        "U" -> up(rest_of_instructions, state)
        "D" -> down(rest_of_instructions, state)
        "R" -> right(rest_of_instructions, state)
        "L" -> left(rest_of_instructions, state)
      end
    end

    def code_at(model, position) do 
      code = model |> Enum.at(position.x) |> Enum.at(position.y)
      case code do
        x when is_integer(x) -> Integer.to_string(x)
        x -> x 
      end
    end

    def change_position(state, new_position) do
      if( new_position.x < 0 or 
          new_position.y < 0 or
         (state.model |> Enum.at(new_position.x) == nil) or 
         (state.model |> Enum.at(new_position.x) |> Enum.at(new_position.y) == nil) or
         Keypad.code_at(state.model, new_position) == "0") do
        state.position
      else
        new_position
      end
    end

    def up(instructions, state) do
      new_position = Keypad.change_position(state, %{state.position | x: state.position.x - 1})
      find_code(instructions, %{state | position: new_position})
    end

    def down(instructions, state) do
      new_position = Keypad.change_position(state, %{state.position | x: state.position.x + 1})
      find_code(instructions, %{state | position: new_position})
    end
    
    def right(instructions, state) do
      new_position = Keypad.change_position(state, %{state.position | y: state.position.y + 1})
      find_code(instructions, %{state | position: new_position})
    end

    def left(instructions, state) do
      new_position = Keypad.change_position(state, %{state.position | y: state.position.y - 1})
      find_code(instructions, %{state | position: new_position})
    end
  end
  
  alias Keypad

  def run1(input \\ @input) do
    %{code: code} = input
    |> Enum.to_list
    |> List.foldl(%Keypad{model: @model1}, fn(instructions, acc) -> Keypad.find_code(String.graphemes(instructions), acc) end)

    code
  end

  def run2(input \\ @input) do
    %{code: code} = input
    |> Enum.to_list
    |> List.foldl(%Keypad{position: %{x: 2, y: 0}, model: @model2}, fn(instructions, acc) -> Keypad.find_code(String.graphemes(instructions), acc) end)

    code
  end

end
