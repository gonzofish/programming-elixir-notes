defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command line parsing and the dispatching to
  various functions that end up generating the table
  of the last _n_ issues in a Github project
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
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

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
    |> last(count)
  end

  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end
  
  def sort_descending(issues) do
    issues
    |> Enum.sort(fn issue1, issue2 ->
      issue1["created_at"] >= issue2["created_at"]
    end)
  end

  def last(recent_issues, count) do
    recent_issues
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
