defmodule Educator.AAA.S3 do
  @moduledoc "Direct uploads to AWS S3."

  alias Educator.AAA.S3.Config
  alias Educator.AAA.S3.Policy
  alias Educator.AAA.S3.SigningOpts

  alias Educator.AAA.Media.Upload

  @type result :: {:ok, any()} | {:error, any()}

  @spec bucket() :: String.t() | nil
  def bucket do
    :educator_aaa
    |> Application.get_env(:aws)
    |> Keyword.get(:bucket)
    |> case do
      {:system, env_var} -> System.get_env(env_var)
      bucket -> bucket
    end
  end

  @spec bucket_url() :: String.t()
  def bucket_url, do: bucket_url(config())

  @spec bucket_url(Config.t()) :: String.t()
  def bucket_url(%Config{bucket: bucket, region: region}),
    do: "https://s3.#{region}.amazonaws.com/#{bucket}"

  @spec authenticated_upload_params(Upload.t(), Keyword.t()) :: map()
  def authenticated_upload_params(
        %Upload{
          mimetype: mimetype,
          key: key
        } = upload,
        overrides \\ []
      ) do
    %Config{bucket: bucket} = config = config()

    %SigningOpts{
      algorithm: algorithm,
      scope: scope,
      acl: acl
    } = opts = SigningOpts.build(config, overrides)

    policy =
      config
      |> Policy.build(upload, opts)
      |> Policy.encode()

    signature =
      config
      |> signing_key(opts)
      |> sign(policy)

    %{
      url: bucket_url(config),
      data: %{
        acl: acl,
        bucket: bucket,
        key: key,
        policy: policy,
        "Content-Type": mimetype,
        "x-amz-algorithm": algorithm,
        "x-amz-credential": scope,
        "x-amz-date": SigningOpts.date(opts, :datetime),
        "x-amz-signature": signature
      }
    }
  end

  @spec head(String.t()) :: result()
  def head(key) do
    bucket()
    |> ExAws.S3.head_object(key)
    |> ExAws.request()
  end

  @spec exists?(String.t()) :: boolean() | no_return
  def exists?(key) do
    case head(key) do
      {:ok, %{status_code: 200}} -> true
      _ -> false
    end
  end

  @spec copy(String.t(), String.t()) :: result()
  def copy(src_key, dst_key) when src_key != dst_key do
    bucket = bucket()

    bucket
    |> ExAws.S3.put_object_copy(dst_key, bucket, src_key, acl: :public_read)
    |> ExAws.request()
  end

  @spec delete(String.t()) :: result()
  def delete(key) do
    bucket()
    |> ExAws.S3.delete_object(key)
    |> ExAws.request()
  end

  @spec config :: Config.t()
  defp config do
    s3_config_with_bucket =
      :s3
      |> ExAws.Config.new()
      |> Map.put(:bucket, bucket())

    struct(Config, s3_config_with_bucket)
  end

  defp signing_key(
         %Config{secret_access_key: secret_access_key, region: region},
         %SigningOpts{} = opts
       ) do
    "AWS4#{secret_access_key}"
    |> hmac_sha256(SigningOpts.date(opts, :date))
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
