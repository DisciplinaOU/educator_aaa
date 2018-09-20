use Mix.Config

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
