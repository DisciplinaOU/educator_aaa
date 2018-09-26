defmodule Educator.AAA.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    execute("create type upload_state as enum('pending', 'finished')", "drop type upload_state")

    create table(:uploads) do
      add(:key, :string, null: false)
      add(:mimetype, :string, null: false)
      add(:state, :upload_state, null: false)
      add(:size, :int)

      timestamps()
    end

    create(unique_index(:uploads, [:key]))
  end
end
