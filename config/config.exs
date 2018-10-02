use Mix.Config

# NOTE(smaximov):
#   This does not currently do anything, but it will allow to use Jason
#   as the JSON implementation for Phoenix when 1.4 lands.
config :phoenix, :json_library, Jason

config :phoenix, :format_encoders, json: Jason

config :ecto, :json_library, Jason

config :educator_aaa, Educator.AAA.Repo,
  types: Educator.AAA.PostgresTypes,
  loggers: [Educator.AAA.Instrumenters.Ecto, Ecto.LogEntry]

config :educator_aaa,
  namespace: Educator.AAA,
  ecto_repos: [Educator.AAA.Repo]

config :educator_aaa, Educator.AAA.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vIORUnar4MzRXy4IaiwM0iJAvFlVGvgUnn1IWVhdGKc3coQARFx/uErUKc0RHf6D",
  render_errors: [view: Educator.AAA.ErrorView, accepts: ~w(json)],
  pubsub: [name: Educator.AAA.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [Educator.AAA.Instrumenters.Phoenix]

config :educator_aaa, :aws, bucket: {:system, "AWS_S3_BUCKET"}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:educator_id, :request_id]

config :prometheus, Educator.AAA.Instrumenters.Phoenix,
  controller_call_labels: [:controller, :action],
  duration_buckets: [
    10,
    25,
    50,
    100,
    250,
    500,
    1000,
    2500,
    5000,
    10_000,
    25_000,
    50_000,
    100_000,
    250_000,
    500_000,
    1_000_000,
    2_500_000,
    5_000_000,
    10_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

config :prometheus, Educator.AAA.Instrumenters.Pipeline,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  duration_buckets: [
    10,
    100,
    1_000,
    10_000,
    100_000,
    300_000,
    500_000,
    750_000,
    1_000_000,
    1_500_000,
    2_000_000,
    3_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

import_config "#{Mix.env()}.exs"
