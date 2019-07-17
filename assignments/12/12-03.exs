defmodule ErrorTrap do
  def ok!({:ok, data }) do
    data
  end

  def ok!({_, error }) do
    raise "THAT FAILED! Here's the error message: #{error}"
  end
end
