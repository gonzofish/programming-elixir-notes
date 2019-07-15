defmodule Weather do
  @moduledoc """
  Documentation for Weather.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Weather.hello()
      :world

  """
  def main(argv) do
    argv
    |> CliParser.parse()
    |> NoaaWeather.fetch()
    |> _format_output()
    |> IO.puts()
  end

  defp _format_output({:ok, weather}) do
    OutputFormatter.format(weather)
  end

  defp _format_output({_, message}) do
    message
  end
end
