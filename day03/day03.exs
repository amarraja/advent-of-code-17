defmodule Day03 do

  @input 265149

  def part_1 do
    {x, y, v} = spiral_grid_stream() |> Stream.drop(@input - 1) |> Stream.take(1) |> Enum.to_list |> hd
    diff = abs(x) + abs(y)
    "Steps for #{v} = #{diff}"
  end

  def part_2 do
    spiral_grid_stream_children
    |> Stream.drop_while(fn { _x, _y, v } -> v <= @input end)
    |> Stream.take(1)
    |> Enum.to_list
    |> hd
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


  def spiral_grid_stream_children do
    { :ok, state } = Agent.start_link(fn -> %{} end)

    dirs = Stream.concat([:none], directions())
    Stream.scan(dirs, { 0, 0, 1 }, fn direction, { x, y, v } ->
      { x, y, v } = case direction do
        :right -> { x + 1, y, 0 }
        :up ->    { x, y + 1, 0 }
        :left ->  { x - 1, y, 0 }
        :down ->  { x, y - 1, 0 }
        :none -> { x, y, v } #only the first item
      end

      v = case v do
        1 -> 1
        _ -> get_value(state, x, y)
      end

      Agent.update(state, fn map -> Map.put(map, {x, y}, v) end)
      {x, y, v}
    end)

  end

  def get_value(state, x, y) do
    neighbours = Agent.get(state, fn m ->
      keys = [
        { x - 1, y + 1 },  { x, y + 1 },  { x + 1, y + 1 },
        { x - 1, y     },                 { x + 1, y },
        { x - 1, y - 1 },  { x, y - 1 },  { x + 1, y - 1 }
      ]
      keys |> Enum.map(fn k -> Map.get(m, k, 0) end)
    end)
    Enum.sum(neighbours)
  end
  



end


Day03.part_1
|> IO.inspect

Day03.part_2
|> IO.inspect
