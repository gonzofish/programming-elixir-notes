defmodule Ropes do
  def printable_ascii?(chars) when is_list(chars) do
    Enum.all?(chars, &(&1 >= ?\s and &1 <= ?~))
  end

  def anagram?(word1, word2) do
    Enum.sort(word1) == Enum.sort(word2)
  end

  def calculate(char_list), do: do_calculate(char_list, 0)
  
  defp do_calculate([], value), do: value
  defp do_calculate([?+ | tail], value) do
    value + do_calculate(tail, 0)
  end
  defp do_calculate([?- | tail], value) do
    value - do_calculate(tail, 0)
  end
  defp do_calculate([?* | tail], value) do
    value * do_calculate(tail, 0)
  end
  defp do_calculate([?/ | tail], value) do
    div(value, do_calculate(tail, 0))
  end
  defp do_calculate([head | tail], value) when head in '0123456789' do
    do_calculate(tail, value * 10 + char_to_num(head))
  end
  defp do_calculate([_ | tail], value) do
    do_calculate(tail, value)
  end

  defp char_to_num(num_char), do: num_char - ?0
end
