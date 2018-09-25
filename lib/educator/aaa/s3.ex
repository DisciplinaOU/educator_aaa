defmodule Educator.AAA.S3 do
  @moduledoc "Direct uploads to AWS S3."

  use Agent

  alias Educator.AAA.S3.{Config, Policy, SignatureMeta, Upload}

  def start_link(config), do: Agent.start_link(fn -> config end, name: __MODULE__)

  @spec config :: Config.t()
  def config, do: Agent.get(__MODULE__, & &1)

  @spec authenticated_upload_params(Config.t(), Upload.t(), Date.t()) :: map()
  def authenticated_upload_params(
        %Config{
          bucket: bucket
        } = config,
        %Upload{
          mimetype: mimetype,
          key: key,
          acl: acl
        } = upload,
        date \\ Date.utc_today()
      ) do
    %SignatureMeta{
      algorithm: algorithm,
      scope: scope
    } = meta = SignatureMeta.build(config, date)

    policy =
      config
      |> Policy.build(upload, meta)
      |> Policy.encode()

    signature =
      config
      |> signing_key(meta)
      |> sign(policy)

    %{
      url: bucket_url(bucket),
      data: %{
        acl: acl,
        bucket: bucket,
        key: key,
        policy: policy,
        "Content-Type": mimetype,
        "x-amz-algorithm": algorithm,
        "x-amz-credential": scope,
        "x-amz-date": SignatureMeta.date(meta, :datetime),
        "x-amz-signature": signature
      }
    }
  end

  @spec bucket_url(String.t()) :: String.t()
  defp bucket_url(bucket), do: "https://#{bucket}.s3.amazonaws.com"

  defp signing_key(
         %Config{secret_access_key: secret_access_key, region: region},
         %SignatureMeta{} = meta
       ) do
    "AWS4#{secret_access_key}"
    |> hmac_sha256(SignatureMeta.date(meta, :date))
    |> hmac_sha256(region)
    |> hmac_sha256("s3")
    |> hmac_sha256("aws4_request")
  end

  @spec sign(String.t(), String.t()) :: String.t()
  defp sign(key, policy) do
    key
    |> hmac_sha256(policy)
    |> Base.encode16(case: :lower)
  end

  @spec hmac_sha256(String.t(), String.t()) :: String.t()
  defp hmac_sha256(key, data), do: :crypto.hmac(:sha256, key, data)
end
