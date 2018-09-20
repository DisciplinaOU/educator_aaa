use Mix.Config

# NOTE(smaximov):
#   This does not currently do anything, but it will allow to use Jason
#   as the JSON implementation for Phoenix when 1.4 lands.
config :phoenix, :json_library, Jason

config :phoenix, :format_encoders, json: Jason

config :ecto, :json_library, Jason

config :educator_aaa, Educator.AAA.Repo, types: Educator.AAA.PostgresTypes

config :educator_aaa,
  namespace: Educator.AAA,
  ecto_repos: [Educator.AAA.Repo]

config :educator_aaa, Educator.AAA.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vIORUnar4MzRXy4IaiwM0iJAvFlVGvgUnn1IWVhdGKc3coQARFx/uErUKc0RHf6D",
  render_errors: [view: Educator.AAA.ErrorView, accepts: ~w(json)],
  pubsub: [name: Educator.AAA.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id]

import_config "#{Mix.env()}.exs"
