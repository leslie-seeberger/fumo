defmodule Fumo.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :username, :citext, null: false
      add :bio, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:user_profiles, [:username])
    create index(:user_profiles, [:user_id])
  end
end
