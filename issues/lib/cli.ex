defmodule Issues.CLI do
  @default_count 4
  @headers %{
    "created_at" => "created_at",
    "number" => " #",
    "title" => "title"
  }
  @fields ["number", "created_at", "title"]

  @moduledoc """
  Handle command line parsing and the dispatching to
  various functions that end up generating the table
  of the last _n_ issues in a Github project
  """

  def main(argv) do
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
    # grab the 2nd element returned from OptionParser.parse
    |> elem(1)
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
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
    |> last(count)
    |> print_table()
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_descending(issues) do
    issues
    |> Enum.sort(fn issue1, issue2 ->
      issue1["created_at"] >= issue2["created_at"]
    end)
  end

  defp last(recent_issues, count) do
    recent_issues
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def print_table(issues) do
    format_table(issues)
    |> IO.puts()
  end

  def format_table(last_issues) do
    # - fields we need: number, created_at, title
    field_widths = get_field_widths([@headers | last_issues])

    # print headers, using padding
    header = do_format_row(@headers, field_widths)
    separator = do_format_separator(field_widths)
    rows = Enum.map(last_issues, &do_format_row(&1, field_widths))

    [header | [separator | rows]]
    |> Enum.join("\n")
  end

  defp get_field_widths(items) do
    @fields
    |> Enum.reduce(%{}, fn field, maxs ->
      field_values = items |> Enum.map(fn item -> do_get_str_len(item[field]) end)
      Map.put(maxs, field, Enum.max(field_values))
    end)
  end

  defp do_get_str_len(value) do
    String.length("#{value}")
  end

  defp do_format_row(row, field_widths) do
    @fields
    |> Enum.map(fn field ->
      value = row[field]

      String.pad_trailing("#{value}", field_widths[field])
    end)
    |> Enum.join(" | ")
  end

  defp do_format_separator(field_widths) do
    @fields
    |> Enum.map(&String.duplicate("-", field_widths[&1]))
    |> Enum.join("-+-")
  end
end
