defmodule Educator.AAA.Repo.Migrations.DropUploadStateAndSize do
  use Ecto.Migration

  def up do
    alter table(:uploads) do
      remove(:size)
      remove(:state)
    end

    execute("drop type upload_state")
  end

  def down do
    execute("create type upload_state as enum('pending', 'finished')")

    alter table(:uploads) do
      add(:state, :upload_state, null: false)
      add(:size, :int)
    end
  end
end
