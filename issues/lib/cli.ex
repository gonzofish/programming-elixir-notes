defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command line parsing and the dispatching to
  various functions that end up generating the table
  of the last _n_ issues in a Github project
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be `-h` or `--help`, which returns :help

  Otherwise it is a Github user name, project name, and (optionally)
  a number of issues to return

  Returns a tuple of `{user, project, count}` or `:help`
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)  # grab the 2nd element returned from OptionParser.parse
    |> do_format_args()
  end

  defp do_format_args([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp do_format_args([user, project]) do
    {user, project, @default_count}
  end

  # this covers a bad argument or -h/--help flags
  defp do_format_args(_) do
    :help
  end
end
