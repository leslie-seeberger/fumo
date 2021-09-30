defmodule Fumo.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fumo.Accounts.User
  alias Fumo.Profiles.UserProfile
  alias Fumo.Repo

  embedded_schema do
    field :email
    field :username
    field :password
  end

  @required_fields ~w/email password username/a

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def to_multi(params \\ %{}) do
    %{"username" => username} = params
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
