defmodule MyList do
  def find_primes(n) when n > 2 do
    for num <- span(2, n),
      Enum.all?(span(2, num - 1), &(rem(num, &1) != 0)) do
      num
    end
  end

  def span(to, to), do: [to]
  def span(from, to) when from > to, do: []
  def span(from, to) do
    [from | span(from + 1, to)]
  end
end
