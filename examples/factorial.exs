defmodule Factorial do
  # pattern-match if n == 0
  def of(0), do: 1
  # if n != 0, run this form
  def of(n) when is_integer(n) and n > 0 do
    n * of(n - 1)
  end
end
