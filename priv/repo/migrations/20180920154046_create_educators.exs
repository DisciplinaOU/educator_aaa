defmodule Educator.AAA.Repo.Migrations.CreateEducators do
  use Ecto.Migration

  def change do
    execute("create extension if not exists citext;", "")

    create table("educators") do
      add(:name, :text, null: false)
      add(:email, :citext, null: false)
      add(:password_digest, :text, null: false)

      timestamps()
    end

    create(unique_index("educators", [:name]))
    create(unique_index("educators", [:email]))
  end
end
