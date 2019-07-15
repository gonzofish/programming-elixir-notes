defmodule OutputFormatter do
  def format(weather) do
    output_fields = _get_output_fields()

    max_label_width =
      output_fields
      |> Enum.filter(fn [value | _] -> value != nil end)
      |> Enum.map(fn [value | _] -> String.length("#{value}") end)
      |> Enum.max()

    rows =
      output_fields
      |> Enum.map(&_pad_label(&1, max_label_width))
      |> Enum.map(&_format_field(weather, &1))

    rows
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

  defp _format_field(weather, [nil | value_fields]) do
    _format_value(weather, value_fields)
  end

  defp _format_field(weather, [label | value_fields]) do
    "#{label} #{_format_value(weather, value_fields)}"
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

  defp _pad_label([label | other_args], max_width)
       when is_binary(label) and is_integer(max_width) do
    new_label = String.pad_leading(label, max_width)

    [new_label | other_args]
  end

  defp _pad_label(args, _) do
    args
  end
end
