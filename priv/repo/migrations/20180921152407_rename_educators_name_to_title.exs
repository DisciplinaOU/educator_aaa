defmodule Educator.AAA.Repo.Migrations.RenameEducatorsNameToTitle do
  use Ecto.Migration

  def up do
    rename(table("educators"), :name, to: :title)
    drop(index("educators", [:name]))
    create(unique_index("educators", [:title]))
  end

  def down do
    rename(table("educators"), :title, to: :name)
    drop(index("educators", [:title]))
    create(unique_index("educators", [:name]))
  end
end
