defmodule MEnum do
  def all?([], _), do: true
  def all?([head | _], value) when head != value do
    false
  end
  def all?([_ | tail], value) do
    all?(tail, value)
  end
end
