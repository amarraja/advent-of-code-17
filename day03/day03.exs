defmodule Day03 do

  @input 265149

  def part_1 do
    {x, y, v} = spiral_grid_stream() |> Stream.drop(@input - 1) |> Stream.take(1) |> Enum.to_list |> hd
    diff = abs(x) + abs(y)
    "Steps for #{v} = #{diff}"
  end


  def directions do
    Stream.cycle([[:right, :up], [:left, :down]])
    |> Stream.zip(Stream.iterate(1, &(&1+1)))
    |> Stream.map(fn {directions, count} ->
      Enum.map(directions, fn d -> List.duplicate(d, count) end)
    end)
    |> Stream.flat_map(fn x -> x end)
    |> Stream.concat
  end

  def spiral_grid_stream do
    dirs = Stream.concat([:none], directions())
    Stream.scan(dirs, { 0, 0, 1 }, fn direction, { x, y, v } ->
      case direction do
        :right -> { x + 1, y, v + 1 }
        :up ->    { x, y + 1, v + 1 }
        :left ->  { x - 1, y, v + 1 }
        :down ->  { x, y - 1, v + 1 }
        :none -> { x, y, v } #only the first item
      end
    end)
  end

end


Day03.part_1
|> IO.inspect
