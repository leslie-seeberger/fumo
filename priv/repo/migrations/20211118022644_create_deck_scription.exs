defmodule Fumo.Repo.Migrations.CreateDeckSubscription do
  use Ecto.Migration

  def change do
    create table(:deck_subscription, primary_key: false) do
      add :deck_id, references(:decks, on_delete: :nothing), primary_key: true
      add :user_id, references(:users, on_delete: :nothing), primary_key: true
    end

    create index(:deck_subscription, [:deck_id])
    create index(:deck_subscription, [:user_id])
    create index(:deck_subscription, [:deck_id, :user_id], unique: true)
  end
end
