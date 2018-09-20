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
