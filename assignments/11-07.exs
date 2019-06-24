defmodule Orders do
  @tax_rates [ NC: 0.075, TX: 0.08 ]

  def from_file(file) do
    device = File.open!(file)

    headers = device
    |> IO.read(:line)
    |> split_row()
    |> Enum.map(&(:"#{&1}"))

    device
    |> IO.stream(:line)
    |> Enum.map(&Enum.zip(headers, split_row(&1)))
    |> Enum.map(&format_values/1)
    |> Enum.map(&with_tax/1)
  end

  defp split_row(row) do
    row
    |> String.replace(~r{\n$}, "")
    |> String.split(",")
  end

  defp format_values(order) do
    id = Keyword.get(order, :id) |> String.to_integer
    net_amount = Keyword.get(order, :net_amount) |> String.to_float
    state = Keyword.get(order, :ship_to)
    |> String.replace(":", "")
    |> String.to_atom

    [
      id: id,
      net_amount: net_amount,
      state: state
    ]
  end

  defp with_tax(order) do
    net_amount = Keyword.get(order, :net_amount)
    state = Keyword.get(order, :state)
    rate  = Keyword.get(@tax_rates, state, 0)
    
    Keyword.put(order, :total_amount, net_amount * (1 + rate))
  end
end
