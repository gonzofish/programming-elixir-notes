# ?<character> gets the integer of the character
# ?a = 97, ?z = 122
defmodule Codex do
  def caesar([], _), do: []
  def caesar([head | tail], n) when head + n > ?z do
    [(?a - 1) + ((head + n) - ?z) | caesar(tail, n)]
  end
  def caesar([head | tail], n) do
    [head + n | caesar(tail, n)]
  end
end
