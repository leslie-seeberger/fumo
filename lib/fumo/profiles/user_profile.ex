defmodule Fumo.Profiles.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fumo.Validations

  @derive {Phoenix.Param, key: :username}

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
    |> unsafe_validate_unique(:username, Fumo.Repo)
    |> unique_constraint(:username)
    |> Validations.validate_username()
  end

  defp validate_bio(changeset) do
    changeset
    |> validate_length(:bio, max: 300)
  end
end
