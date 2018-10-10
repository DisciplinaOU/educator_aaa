defmodule Educator.AAA.ReleaseTasks do
  @moduledoc false

  def migrate(_args) do
    start()

    do_migrate()

    stop()
  end

  @start_apps [:crypto, :ssl, :postgrex, :ecto]
  @repos Application.get_env(Educator.AAA.Mixfile.project()[:app], :ecto_repos)

  defp start do
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    Enum.each(@repos, & &1.start_link(pool_size: 1))
  end

  defp stop, do: :init.stop()

  defp do_migrate, do: Enum.each(@repos, &run_migrations_for/1)

  defp run_migrations_for(repo) do
    migrations_path = priv_path_for(repo, "migrations")

    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp priv_path_for(repo, path) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, path])
  end
end
