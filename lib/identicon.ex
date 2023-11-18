defmodule Identicon do
  def main(input) do
    input
    |> hash
    |> pick_color
  end

  def hash(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex:  [red, green, blue | _]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end
end 
