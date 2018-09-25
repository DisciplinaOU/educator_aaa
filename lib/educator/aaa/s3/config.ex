defmodule Educator.AAA.S3.Config do
  @moduledoc false

  @enforce_keys [:access_key_id, :secret_access_key, :region, :bucket]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          access_key_id: String.t(),
          secret_access_key: String.t(),
          region: String.t(),
          bucket: String.t()
        }

  @spec load_from_env :: t() | no_return
  def load_from_env do
    %__MODULE__{
      access_key_id: env("AWS_ACCESS_KEY_ID"),
      secret_access_key: env("AWS_SECRET_ACCESS_KEY"),
      region: env("AWS_REGION"),
      bucket: env("AWS_S3_BUCKET")
    }
  end

  @spec env(String.t()) :: String.t() | no_return
  def env(name) do
    System.get_env(name) || raise "Expected environment variable #{name} to be set"
  end
end
