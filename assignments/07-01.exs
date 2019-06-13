defmodule AssignList do
  def mapsum([], _), do: []
  def mapsum([head | tail], func), do: [func.(head) | mapsum(tail, func)]
end
