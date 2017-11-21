defmodule Vr.Convert do
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> +(@epoch)
    |> :calendar.gregorian_seconds_to_datetime
  end

  def to_timestamp(datetime) do
    datetime
    |> :calendar.datetime_to_gregorian_seconds
    |> -(@epoch)
  end
end
