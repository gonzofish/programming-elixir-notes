defmodule FizzBuzz do
  def run(n) do
    do_fizzy([
      rem(n, 3),
      rem(n, 5),
      n
    ])
  end

  defp do_fizzy(values) do
    case values do
      [0, 0, _] ->
        "FizzBuzz"
      [0, _, _] ->
        "Fizz"
      [_, 0, _] ->
        "Buzz"
      [_, _, n] ->
        n
    end
  end
end

