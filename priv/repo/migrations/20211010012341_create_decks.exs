defmodule Fumo.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :title, :string, null: false
      add :description, :text
      add :is_published, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:decks, [:user_id])
    create index(:decks, [:title])
  end
end
