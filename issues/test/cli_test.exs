defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  # so we don't have to do Issues.CLI.parse_args
  # everytime
  import Issues.CLI, only: [parse_args: 1]

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
end
