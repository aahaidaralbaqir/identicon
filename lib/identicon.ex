defmodule Identicon do
  def main(input) do
    input
    |> hash
    |> pick_color
	  |> build_grid
  end

  def hash(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex:  [red, green, blue | _]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def build_grid(%Identicon.Image{hex: hex} = _) do
    hex
    |> Enum.chunk_every(3)
  end
end 
