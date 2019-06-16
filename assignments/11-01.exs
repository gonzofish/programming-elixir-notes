defmodule Ropes do
  def is_printable_ascii(chars) when is_list(chars) do
    Enum.all?(chars, &(&1 >= ?\s and &1 <= ?~))
  end
end
