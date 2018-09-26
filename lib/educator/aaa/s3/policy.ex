defmodule Educator.AAA.S3.Policy do
  @moduledoc "Security policy for authenticated S3 requests."

  alias Educator.AAA.S3.Config
  alias Educator.AAA.S3.SigningOpts

  alias Educator.AAA.Media.Upload

  @derive Jason.Encoder
  @enforce_keys [:expiration, :conditions]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          expiration: String.t(),
          conditions: [condition(), ...]
        }

  @type condition :: [String.t()] | %{required(String.t() | atom) => String.t()}

  @spec build(Config.t(), Upload.t(), SigningOpts.t()) :: t() | no_return
  def build(
        %Config{bucket: bucket},
        %Upload{
          mimetype: mimetype,
          key: key
        },
        %SigningOpts{
          algorithm: algorithm,
          scope: scope,
          acl: acl,
          expires_in: expires_in,
          content_length: content_length
        } = opts
      ) do
    %__MODULE__{
      expiration: expiration_from_now(expires_in),
      conditions: [
        %{acl: acl},
        %{bucket: bucket},
        %{key: key},
        %{"Content-Type": mimetype},
        %{"x-amz-algorithm": algorithm},
        %{"x-amz-credential": scope},
        %{"x-amz-date": SigningOpts.date(opts, :datetime)},
        ["content-length-range", content_length.first, content_length.last]
      ]
    }
  end

  @spec encode(t()) :: String.t()
  def encode(%__MODULE__{} = policy) do
    policy
    |> Jason.encode!()
    |> Base.encode64()
  end

  @spec expiration_from_now(pos_integer()) :: String.t()
  defp expiration_from_now(seconds) do
    :second
    |> System.system_time()
    |> Kernel.+(seconds)
    |> DateTime.from_unix!(:second)
    |> DateTime.to_iso8601()
  end
end
