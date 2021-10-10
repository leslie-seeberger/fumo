defmodule Fumo.UserRegistration do
  use Ecto.Schema
  alias Fumo.Validations
  import Ecto.Changeset

  alias Fumo.Accounts.User
  alias Fumo.Profiles.UserProfile
  alias Fumo.Repo

  embedded_schema do
    field :email
    field :username
    field :password
    field :hashed_password
  end

  @required_fields ~w/email password username/a

  def changeset(registration, params \\ %{}) do
    registration
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> Validations.validate_password([])
    |> Validations.validate_username()
    |> Validations.validate_email()
  end

  def to_multi(params \\ %{}) do
    username = Map.get(params, "username", "")
    Ecto.Multi.new
    |> Ecto.Multi.insert(:user, user_changeset(params))
    |> Ecto.Multi.run(:profile, fn _, changes ->
      Repo.insert(profile_changeset(changes, username))
    end)
  end

  defp user_changeset(params) do
    user_params = Map.take(params, ["email", "password"])
    User.registration_changeset(%User{}, user_params)
  end

  defp profile_changeset(changes, username) do
    attrs = %{bio: "", username: username, user_id: changes.user.id}
    UserProfile.changeset(%UserProfile{}, attrs)
  end
end
