defmodule Factorial do
  # pattern-match if n == 0
  def of(0), do: 1
  # if n != 0, run this form
  def of(n), do: n * do(n - 1)
end
