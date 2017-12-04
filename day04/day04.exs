defmodule Day04 do

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&is_valid/1)
    |> Enum.count
  end

  def is_valid(phrase) do
    words = String.split(phrase)
    unique = Enum.uniq(words)
    Enum.count(words) == Enum.count(unique)
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&is_valid_2/1)
    |> Enum.count
  end

  def is_valid_2(phrase) do
    words = phrase |> String.split() |> Enum.map(fn s ->
      s |> String.codepoints |> Enum.sort |> Enum.join
    end)
    unique = Enum.uniq(words)
    Enum.count(words) == Enum.count(unique)
  end

end

File.read!("input")
|> Day04.part1
|> IO.inspect

File.read!("input")
|> Day04.part2
|> IO.inspect
