defmodule NoaaWeather do
  import SweetXml

  @fields [
    {"dewpoint_string", :dewpoint},
    {"location", :location},
    {"observation_time_rfc822", :last_updated},
    {"pressure_in", :altimeter},
    {"pressure_mb", :msl_pressure},
    {"relative_humidity", :relative_humidity},
    {"temperature_string", :temperature},
    {"visibility_mi", :visibility},
    {"weather", :weather},
    {"wind_dir", :wind_direction},
    {"wind_kt", :wind_kt},
    {"wind_mph", :wind_mph}
  ]

  def fetch(code) do
    _get_url(code)
    |> HTTPoison.get()
    |> _parse_xml(code)
  end

  defp _get_url(code) do
    "https://w1.weather.gov/xml/current_obs/#{code}.xml"
  end

  defp _parse_xml({:ok, %{body: body, status_code: 200}}, _) do
    {
      :ok,
      body |> _xml_to_map()
    }
  end

  defp _parse_xml({_, _}, code) do
    {
      :error,
      "Could not retrieve weather for #{code}"
    }
  end

  defp _xml_to_map(xml_doc) do
    @fields
    |> Enum.map(fn {xml_field, field} ->
      {field, _get_xml_value(xml_doc, xml_field)}
    end)

    # fields to grab from `current_observation`:
    # - Location (location)
    # - Last Updated (observation_time_rfc822)
    # - Weather (weather)
    # - Temperature (temperature_string) 
    # - Dewpoint (dewpoint_string)
    # - Relative humidity ("#{relative_humidity}%")
    # - Wind ("#{wind_dir} at #{wind_mph} MPH (#{wind_kt} KT))
    # - Visibility ("#{visibility_mi} Miles")
    # - MSL Pressure ("#{pressure_mb} mb")
    # - Altimeter ("#{pressure_hg} in Hg")
  end

  defp _get_xml_value(xml_doc, field) do
    xml_doc |> xpath(~x"//current_observation/#{field}/text()")
  end
end
