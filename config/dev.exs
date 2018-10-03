use Mix.Config

config :educator_aaa, Educator.AAA.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "$metadata[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :educator_aaa, Educator.AAA.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "educator_aaa_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool_size: 10

config :ex_aws,
  access_key_id: [
    {:system, "AWS_ACCESS_KEY_ID"},
    {:awscli, "educator_aaa", 30}
  ],
  secret_access_key: [
    {:system, "AWS_SECRET_ACCESS_KEY"},
    {:awscli, "educator_aaa", 30}
  ],
  region: System.get_env("AWS_S3_BUCKET") || "eu-central-1"
