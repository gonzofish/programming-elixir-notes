defmodule CliParser do
  def parse(argv) do
    OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> _format_args()
  end

  defp _format_args([code]), do: code

  defp _format_args(_) do
    IO.puts("""
    Fetch Current NOAA Weather conditions by location code

    usage: noaa <location code>
    """)

    System.halt()
  end
end
