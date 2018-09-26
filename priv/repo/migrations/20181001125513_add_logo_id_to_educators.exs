defmodule Educator.AAA.Repo.Migrations.AddLogoIdToEducators do
  use Ecto.Migration

  def change do
    alter table(:educators) do
      add(:logo_id, references(:uploads, on_delete: :nilify_all))
    end

    create(unique_index(:educators, [:logo_id]))
  end
end
