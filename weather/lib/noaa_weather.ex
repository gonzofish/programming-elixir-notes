defmodule NoaaWeather do
  require Logger
  import SweetXml

  @fields [
    {"dewpoint_string", :dewpoint},
    {"latitude", :latitude},
    {"location", :location},
    {"longitude", :longitude},
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
    Logger.info("Fetching weather information for \"#{code}\"")

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
    Logger.error("There was an error fetching weather info for \"#{code}\"")

    {
      :error,
      "Could not retrieve weather for \"#{code}\""
    }
  end

  defp _xml_to_map(xml_doc) do
    Logger.debug("Mapping NOAA XML into a Keyword list")

    @fields
    |> Enum.map(fn {xml_field, field} ->
      {field, _get_xml_value(xml_doc, xml_field)}
    end)
  end

  defp _get_xml_value(xml_doc, field) do
    Logger.debug("Extracting the value for \"#{field}\" from XML")
    xml_doc |> xpath(~x"//current_observation/#{field}/text()")
  end
end
