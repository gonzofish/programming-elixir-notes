defmodule StringFormat do
  def center(strings) do
    print_centered(strings, get_max_length(strings))
  end

  defp get_max_length([]), do: 0
  defp get_max_length([head | tail]) do
    Kernel.max(String.length(head), get_max_length(tail))
  end

  defp print_centered([head], max_length), do: do_print(head, max_length)
  defp print_centered([head | tail], max_length) do
    do_print(head, max_length)
    print_centered(tail, max_length)
  end

  defp do_print(value, max_length) do
    value_length = String.length(value)
    pad_length = value_length + div(max_length - value_length, 2)
    
    IO.puts String.pad_leading(value, pad_length, " ")
  end
end
