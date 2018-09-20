# NOTE(smaximov):
#   Distillery (as of v2.0.10) does not yet packages it's formatter configuration,
#   so I've copiend it from the current master (ref 51b4145e33).
#
#   See also: https://github.com/bitwalker/distillery/pull/543
distillery_locals_without_parens = [
  release: 2,
  environment: 2,
  plugin: 2,
  command: 2,
  command: 3,
  command: 4,
  option: 2,
  option: 3,
  option: 4,
  require_global: 1,
  set: 1
]

# NOTE(smaximov):
#   Phoenix Framework (as of v1.3.4) does not yet provides/exports its formatter
#   configuration, so I've copied it from the current master (ref b8a4a1f35672892)
phoenix_locals_without_parens = [
  # Phoenix.Channel
  intercept: 1,

  # Phoenix.Router
  connect: 3,
  connect: 4,
  delete: 3,
  delete: 4,
  forward: 2,
  forward: 3,
  forward: 4,
  get: 3,
  get: 4,
  head: 3,
  head: 4,
  match: 4,
  match: 5,
  options: 3,
  options: 4,
  patch: 3,
  patch: 4,
  pipeline: 2,
  pipe_through: 1,
  post: 3,
  post: 4,
  put: 3,
  put: 4,
  resources: 2,
  resources: 3,
  resources: 4,
  trace: 4,

  # Phoenix.Controller
  action_fallback: 1,

  # Phoenix.Endpoint
  plug: 1,
  plug: 2,
  socket: 2,
  socket: 3,

  # Phoenix.Socket
  channel: 2,
  channel: 3,

  # Phoenix.ChannelTest
  assert_broadcast: 2,
  assert_broadcast: 3,
  assert_push: 2,
  assert_push: 3,
  assert_reply: 2,
  assert_reply: 3,
  assert_reply: 4,
  refute_broadcast: 2,
  refute_broadcast: 3,
  refute_push: 2,
  refute_push: 3,
  refute_reply: 2,
  refute_reply: 3,
  refute_reply: 4,

  # Phoenix.ConnTest
  assert_error_sent: 2
]

[
  inputs: [".formatter.exs", "mix.exs", "{db,config,lib,test,rel}/**/*.{ex,exs}"],
  locals_without_parens: distillery_locals_without_parens ++ phoenix_locals_without_parens,
  import_deps: ~w[
    ecto distillery
  ]a
]
