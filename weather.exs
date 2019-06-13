defmodule WeatherHistory do
  def for_location([], _), do: []
  def for_location([[time, location, temp, rain] | tail], location) do
    [[time, temp, rain] | for_location(tail, location)]
  end
  def for_location([_ | tail], location), do: for_location(tail, location)
end
