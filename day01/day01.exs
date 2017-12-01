defmodule Day01 do
    
    def run(input) do
      numbers = parse(input)
      pairs = Enum.zip(numbers, tl(numbers) ++ [hd(numbers)])

      Enum.reduce(pairs, 0, fn(pair, acc) ->
        case pair do
          { x, x } -> acc + x
          _ -> acc
        end
      end)
    end

    def run_part2(input) do
      numbers = parse(input)
      length = Enum.count(numbers)
      step = div(length, 2)

      numbers
      |> Stream.with_index
      |> Enum.reduce(0, fn({ number, index }, acc) ->
        other_index = rem(index + step, length)
        cond do
          Enum.at(numbers,  other_index) == number -> acc + number
          true -> acc
        end
      end)
    end

    def parse(input) do
      input |> String.codepoints |> Enum.map(&String.to_integer/1)
    end

end

ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  test "day1 examples" do
    assert Day01.run("1122") == 3
    assert Day01.run("1111") == 4
    assert Day01.run("1234") == 0
    assert Day01.run("91212129") == 9
  end

  test "day2 examples" do
    assert Day01.run_part2("1212") == 6
    assert Day01.run_part2("1221") == 0
    assert Day01.run_part2("123425") == 4
    assert Day01.run_part2("123123") == 12
    assert Day01.run_part2("12131415") == 4
  end

end

File.read!("day01.txt")
|> Day01.run
|> IO.inspect

File.read!("day01.txt")
|> Day01.run_part2
|> IO.inspect
