defmodule Educator.AAA.S3.SignatureMeta do
  @moduledoc "Information used to create upload signature."

  alias Educator.AAA.S3.Config

  @enforce_keys [:date, :scope]
  defstruct date: nil, scope: nil, algorithm: "AWS4-HMAС-SHA256"

  @type t :: %__MODULE__{
          date: Date.t(),
          scope: String.t(),
          algorithm: String.t()
        }

  @spec build(Config.t(), Date.t()) :: t()
  def build(%Config{} = config, date \\ Date.utc_today()) do
    %__MODULE__{
      date: date,
      scope: credential(config, date)
    }
  end

  @spec date(t(), :date | :datetime) :: String.t()
  def date(%__MODULE__{date: date}, :date) do
    Date.to_iso8601(date, :basic)
  end

  def date(%__MODULE__{date: date}, :datetime) do
    date
    |> utc_datetime_from_date()
    |> DateTime.to_iso8601(:basic)
  end

  @spec credential(Config.t(), Date.t()) :: String.t()
  defp credential(%Config{region: region, access_key_id: access_key_id}, date) do
    date_string = Date.to_iso8601(date, :basic)

    "#{access_key_id}/#{date_string}/#{region}/s3/aws4_request"
  end

  @spec utc_datetime_from_date(Date.t()) :: DateTime.t()
  def utc_datetime_from_date(%Date{calendar: calendar, year: year, month: month, day: day}) do
    %DateTime{
      calendar: calendar,
      year: year,
      month: month,
      day: day,
      hour: 0,
      minute: 0,
      second: 0,
      microsecond: {0, 0},
      std_offset: 0,
      utc_offset: 0,
      zone_abbr: "UTC",
      time_zone: "Etc/UTC"
    }
  end
end
