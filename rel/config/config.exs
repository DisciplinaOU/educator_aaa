use Mix.Config

config :educator_aaa, Educator.AAA.Endpoint,
  load_from_system_env: true,
  server: true,
  version: Application.spec(:educator_aaa, :vsn)

config :logger, level: :info

config :educator_aaa, Educator.AAA.Repo,
  adapter: Ecto.Adapters.Postgres,
  load_from_system_env: true,
  pool_size: 15

config :ex_aws,
  access_key_id:
    System.get_env("AWS_ACCESS_KEY_ID") ||
      raise("expected the AWS_ACCESS_KEY_ID environment variable to be set"),
  secret_access_key:
    System.get_env("AWS_SECRET_ACCESS_KEY") ||
      raise("expected the AWS_SECRET_ACCESS_KEY environment variable to be set"),
  region:
    System.get_env("AWS_REGION") ||
      raise("expected the AWS_REGION environment variable to be set")

config :educator_aaa, :aws,
  bucket:
    System.get_env("AWS_S3_BUCKET") ||
      raise("expected the AWS_S3_BUCKET environment variable to be set")
