defmodule Fumo.Profiles.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_profiles" do
    field :bio, :string
    field :username, :string

    belongs_to :user, Fumo.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:username, :bio, :user_id])
    |> validate_required([:username, :user_id])
    |> validate_username()
    |> validate_bio()
  end

  defp validate_username(changeset) do
    changeset
    |> update_change(:username, &String.downcase/1)
    |> validate_format(:username, ~r/^[a-z0-9_]+$/)
    |> validate_length(:username, min: 3, max: 20)
    |> unsafe_validate_unique(:username, Fumo.Repo)
    |> unique_constraint(:username)
  end

  defp validate_bio(changeset) do
    changeset
    |> validate_length(:bio, max: 300)
  end
end
