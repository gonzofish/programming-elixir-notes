# In the book the author hints you may need
# to use Enum.reverse to accomplish the task
#
# I took this approach to see if I could avoid
# using Enum.reverse and ended up with a function
# that merges two lists
defmodule MEnum do
  def flatten([]), do: []
  def flatten([item]) when not is_list(item) do
    [item]
  end
  def flatten([head | []]) when is_list(head) do
    flatten(head)
  end
  def flatten([head | tail]) when is_list(head) do
    merge(flatten(head), flatten(tail))
  end
  def flatten([head | tail]) do
    [head | flatten(tail)]
  end

  def merge([head_head | head_tail], tail) do
    [head_head | merge(head_tail, tail)]
  end
  def merge([], tail) do
    tail
  end
  def merge(head, tail) do
    [head, tail]
  end
end
