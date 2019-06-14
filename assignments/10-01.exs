defmodule MEnum do
  def all?([], _), do: true
  def all?([head | _], value) when head != value do
    false
  end
  def all?([_ | tail], value) do
    all?(tail, value)
  end

  def each([head], func), do: func.(head)
  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end

  def filter([], _), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end

  def split(collection, index), do: do_split(collection, index, 0)
  defp do_split(collection, index, index) do
    {[], collection}
  end
  defp do_split([head | tail], index, current_index) do
    {first_half, second_half} = do_split(tail, index, current_index + 1)
    {[head | first_half], second_half}
  end
end
