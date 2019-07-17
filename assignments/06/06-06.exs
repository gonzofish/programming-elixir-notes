defmodule Chop do
  def do_guess(actual, _, current) when current == actual do
    IO.puts actual
  end
  def do_guess(actual, low.._high, current) when current > actual do
    guess(actual, low..current - 1)
  end
  def do_guess(actual, _low..high, current) when current < actual do
    guess(actual, current + 1..high)
  end
  def guess(actual, low..high) do
    current = low + div(high - low, 2)
    IO.puts "Is it #{current}?"
    do_guess(actual, low..high, current)
  end
end
