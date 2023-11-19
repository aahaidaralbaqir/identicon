defmodule Identicon do
  def main(input) do
    input
    |> hash
    |> pick_color
	  |> build_grid
    |> filter_odd_squares
    |> create_pixel
    |> draw
    |> save(input)
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

  def create_pixel(%Identicon.Image{grid: grid} = image) do
   pixel = Enum.map grid, fn({_, index}) -> 
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}
      {top_left, bottom_right}
    end
  %Identicon.Image{image | pixel: pixel}
  end
  
  def draw(%Identicon.Image{color: color, pixel: pixel}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save(image, filename) do
    File.write("#{filename}.png", image)
  end
end 
