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
  username: "postgres",
  password: "postgres",
  database: "educator_aaa_dev",
  hostname: "localhost",
  pool_size: 10
