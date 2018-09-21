use Mix.Config

config :educator_aaa, Educator.AAA.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :educator_aaa, Educator.AAA.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "educator_aaa_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
