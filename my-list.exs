defmodule MyList do
  # run a map on a list
  def map([], _), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def reduce([], acc, _), do: acc
  def reduce([head | tail], acc, func) do
    reduce(tail, func.(acc, head), func)
  end

  # add 1
  def add_1(list), do: map(list, &(&1 + 1))

  # get length of list
  def len([]), do: 0
  def len([_ | tail]), do: 1 + len(tail)

  # square each item in the list
  def square(list), do: map(list, &(&1 * &1))
end
