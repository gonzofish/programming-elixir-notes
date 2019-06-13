defmodule AssignList do
  def mapsum([], _), do: []
  def mapsum([head | tail], func), do: [func.(head) | mapsum(tail, func)]

  def max([head]), do: head
  def max([head | tail]) do
    with tail_max <- max(tail),
          true <- tail_max > head do
      tail_max
    else
      false -> head
    end
  end
end
