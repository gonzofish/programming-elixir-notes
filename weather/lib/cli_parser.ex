defmodule CliParser do
  require Logger

  def parse(argv) do
    Logger.debug("Parsing arguments from user")

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
    Logger.info("User passed in a help flag or misused the app")

    IO.puts("""
    Fetch Current NOAA Weather conditions by location code

    usage: noaa <location code>
    """)

    System.halt()
  end
end
