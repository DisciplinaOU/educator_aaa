defmodule Educator.AAA.Endpoint do
  use Phoenix.Endpoint, otp_app: :educator_aaa

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Educator.AAA.PrometheusExporter
  plug Educator.AAA.Instrumenters.Pipeline

  plug Plug.RequestId
  plug Plug.Logger

  @enable_cors_logs if Mix.env() == :prod,
                      do: false,
                      else: [rejected: :warn, invalid: :debug, accepted: :debug]

  # TODO(smaximov): restrict origins.
  plug Corsica,
    origins: "*",
    allow_credentials: true,
    allow_headers: ~w[Content-Type Accept],
    max_age: 600,
    log: @enable_cors_logs

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "educator_aaa_session",
    signing_salt: "nJuCWl7J"

  plug Educator.AAA.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"

      secret_key_base =
        System.get_env("SECRET_KEY_BASE") ||
          raise "expected the SECRET_KEY_BASE environment variable to be set"

      {:ok, Keyword.merge(config, http: [:inet6, port: port], secret_key_base: secret_key_base)}
    else
      {:ok, config}
    end
  end
end
