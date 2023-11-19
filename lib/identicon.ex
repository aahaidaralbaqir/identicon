defmodule Identicon do
  def main(input) do
    input
    |> hash
    |> pick_color
	  |> build_grid
    |> filter_odd_squares
  end

  def hash(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex:  [red, green, blue | _]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror/1)
    |> List.flatten
    |> Enum.with_index
    %Identicon.Image{image| grid: grid}
  end

  def mirror(row) do
    [first, second | _] = row
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _}) ->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end
end 
