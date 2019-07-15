defmodule NoaaWeather do
  def fetch(code) do
    _get_url(code)
    |> HTTPoison.get()
    |> _parse_xml()
  end

  defp _get_url(code) do
    "https://w1.weather.gov/xml/current_obs/#{code}.xml"
  end

  defp _parse_xml({:ok, %{body: body, status_code: code}}) do
    {
      code |> _check_for_error(),
      body
    }
  end

  defp _check_for_error(200), do: :ok
  defp _check_for_error(_), do: :error
end
