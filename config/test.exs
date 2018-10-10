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

config :ex_aws,
  access_key_id: "test_access_key_id",
  secret_access_key: "test_secret_access_key",
  region: "us-east-1"

config :educator_aaa, :aws, bucket: "test.bucket.name"
