defmodule Educator.AAA.S3.SigningOpts do
  @moduledoc "Options for generating policy and signature."

  alias Educator.AAA.S3.Config

  @kb 1024
  @mb 1024 * @kb

  @enforce_keys [:date, :scope]
  defstruct date: nil,
            scope: nil,
            algorithm: "AWS4-HMAC-SHA256",
            acl: "public-read",
            expires_in: 60,
            content_length: (10 * @kb)..(10 * @mb)

  @type t :: %__MODULE__{
          date: Date.t(),
          scope: String.t(),
          algorithm: String.t(),
          acl: String.t(),
          expires_in: pos_integer(),
          content_length: Range.t()
        }

  @spec build(Config.t(), Keyword.t()) :: t()
  def build(%Config{} = config, overrides \\ []) do
    {date, overrides} = Keyword.pop(overrides, :date, Date.utc_today())

    attrs =
      overrides
      |> Map.new()
      |> Map.merge(%{date: date, scope: credential(config, date)})

    struct(__MODULE__, attrs)
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
