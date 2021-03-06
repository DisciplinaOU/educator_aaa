defmodule Educator.AAA.Mixfile do
  use Mix.Project

  def project do
    [
      app: :educator_aaa,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [ignore_warnings: ".dialyzer-ignore.exs", plt_add_apps: [:ex_unit]],
      preferred_cli_env: [dialyzer: :test],

      # Docs
      name: "Educator AAA",
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Educator.AAA.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto, "~> 2.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:distillery, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:comeonin, "~> 4.1"},
      {:argon2_elixir, "~> 1.3"},
      {:corsica, "~> 1.1"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:prometheus, "~> 4.0", override: true},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_ecto, "~> 1.0"},
      {:prometheus_phoenix, "~> 1.2"},
      {:prometheus_plugs, "~> 1.0"},
      {:prometheus_process_collector, "~> 1.3"},
      {:configparser_ex, "~> 2.0", only: [:dev]},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:credo_contrib, "~> 0.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
