defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  # so we don't have to do Issues.CLI.parse_args
  # everytime
  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

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
    result = ["c", "a", "b"]
      |> fake_created_ats()
      |> sort_descending()
    issues = for issue <- result, do: Map.get(issue, "created_at")

    assert issues === ~w{c b a}
  end

  defp fake_created_ats(created_ats) do
    for created_at <- created_ats,
      do: %{"created_at" => created_at, "other_data" => "other_data#{created_at}"}
  end
end
