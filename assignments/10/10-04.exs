defmodule Orders do
  def with_tax(orders, rates) do
    for order <- orders do
      net_amount = Keyword.get(order, :net_amount)
      state = Keyword.get(order, :ship_to)
      rate  = Keyword.get(rates, state, 0)
      
      Keyword.put(order, :total_amount, net_amount * (1 + rate))
    end
  end
end
