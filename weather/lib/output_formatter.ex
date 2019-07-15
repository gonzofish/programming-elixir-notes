defmodule OutputFormatter do
  require Logger

  def format(weather) do
    output_fields = _get_output_fields()
    max_label_length = _find_max_length(output_fields)

    Logger.debug("Max label length: #{max_label_length}")

    output_fields
    |> Enum.map(&_format_field(weather, &1, max_label_length))
    |> Enum.join("\n")
  end

  defp _get_output_fields() do
    [
      [
        nil,
        [:location]
      ],
      [
        nil,
        [:latitude, :longitude],
        fn [lat, lon] ->
          "#{lat} #{lon}\n"
        end
      ],
      ["Last Updated", [:last_updated]],
      ["Weather", [:weather]],
      ["Temperature", [:temperature]],
      ["Dewpoint", [:dewpoint]],
      [
        "Relative humidity",
        [:relative_humidity],
        fn [value] ->
          "#{value}%"
        end
      ],
      [
        "Wind",
        [:wind_direction, :wind_mph, :wind_kt],
        fn [direction, mph, kt] ->
          "#{direction} at #{mph} MPH (#{kt} KT)"
        end
      ],
      [
        "Visibility",
        [:visibility],
        fn [value] ->
          "#{value} Miles"
        end
      ],
      [
        "MSL Pressure",
        [:msl_pressure],
        fn [value] ->
          "#{value} mb"
        end
      ],
      [
        "Altimeter",
        [:altimeter],
        fn [value] ->
          "#{value} in Hg"
        end
      ]
    ]
  end

  defp _find_max_length(output_fields) do
    output_fields
    |> Enum.filter(fn [value | _] -> value != nil end)
    |> Enum.map(fn [value | _] -> String.length("#{value}") end)
    |> Enum.max()
  end

  defp _format_field(weather, [nil | value_fields], _) do
    Logger.debug("Formatting value without a label")
    _format_value(weather, value_fields)
  end

  defp _format_field(weather, [label | value_fields], max_length) do
    Logger.debug("Formatting value for \"#{label}\"")
    "#{_pad_label(label, max_length)} #{_format_value(weather, value_fields)}"
  end

  defp _pad_label(label, max_length) when is_binary(label) do
    Logger.debug("Padding label \"#{label}\" to #{max_length}")
    String.pad_leading(label, max_length)
  end

  defp _format_value(weather, [input_fields]) do
    _run_formatter(weather, input_fields, fn [value] -> "#{value}" end)
  end

  defp _format_value(weather, [input_fields, formatter]) do
    _run_formatter(weather, input_fields, formatter)
  end

  defp _run_formatter(weather, input_fields, formatter) do
    input_fields
    |> Enum.map(&Keyword.get(weather, &1))
    |> formatter.()
  end
end
