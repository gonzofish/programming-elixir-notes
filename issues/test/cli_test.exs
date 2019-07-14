defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  # so we don't have to do Issues.CLI.parse_args
  # everytime
  import Issues.CLI,
    only: [
      format_table: 1,
      parse_args: 1,
      sort_descending: 1
    ]

  test "returns :help for -h & --help switches" do
    assert parse_args(["-h", "pizza"]) == :help
    assert parse_args(["--help", "burgers"]) == :help
  end

  test "returns a tuple with user, project, & count if all are provided" do
    assert parse_args(["fake_user", "some_proj", "15"]) == {"fake_user", "some_proj", 15}
  end

  test "returns a tuple with a default count of 4" do
    assert parse_args(["userx", "projectx"]) == {"userx", "projectx", 4}
  end

  test "sort descending by `created_at` correctly" do
    result =
      ["c", "a", "b"]
      |> fake_created_ats()
      |> sort_descending()

    issues = for issue <- result, do: Map.get(issue, "created_at")

    assert issues === ~w{c b a}
  end

  defp fake_created_ats(created_ats) do
    for created_at <- created_ats,
        do: %{"created_at" => created_at, "other_data" => "other_data#{created_at}"}
  end

  test "format a table for issue number, creation date/time, and title" do
    table = get_fake_issues() |> format_table()

    assert table === get_formatted_table()
  end

  defp get_fake_issues() do
    [
      %{
        "created_at" => "1995-08-15T00:00:01Z",
        "number" => 1234,
        "title" => "Move project to new server"
      },
      %{
        "created_at" => "2010-03-27T04:30:30Z",
        "number" => 2,
        "title" => "Join branches!"
      },
      %{
        "created_at" => "2018-08-03T08:01:00Z",
        "number" => 123,
        "title" => "New child 'Ben'"
      }
    ]
  end

  defp get_formatted_table() do
    [
      " #   | created_at           | title                     ",
      "-----+----------------------+---------------------------",
      "1234 | 1995-08-15T00:00:01Z | Move project to new server",
      "2    | 2010-03-27T04:30:30Z | Join branches!            ",
      "123  | 2018-08-03T08:01:00Z | New child 'Ben'           "
    ]
    |> Enum.join("\n")
  end
end
