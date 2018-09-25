defmodule Educator.AAA.Application do
  @moduledoc "Educator AAA Service"

  use Application

  alias Educator.AAA
  alias Educator.AAA.S3

  def start(_type, _args) do
    load_env()

    children = [
      AAA.Repo,
      AAA.Endpoint,
      {S3, s3_config()}
    ]

    opts = [strategy: :one_for_one, name: AAA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AAA.Endpoint.config_change(changed, removed)

    :ok
  end

  if Mix.env() == :prod do
    defp load_env, do: [nil, nil]
  else
    defp load_env, do: Envy.auto_load()
  end

  if Mix.env() == :test do
    defp s3_config do
      %S3.Config{
        access_key_id: "AWS access key ID",
        secret_access_key: "AWS secret access key",
        region: "AWS region",
        bucket: "AWS S3 bucket"
      }
    end
  else
    defp s3_config, do: S3.Config.load_from_env()
  end
end
