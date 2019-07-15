defmodule GithubIssues do
  require Logger

  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{"User-agent", "Elixir matt.fehskens@gmail.com"}]

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status_code=#{status_code}")
    # this log is excluded at compile time
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
