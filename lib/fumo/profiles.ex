defmodule Fumo.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Fumo.Repo

  alias Fumo.Profiles.UserProfile

  @doc """
  Gets a single user_profile.

  Raises `Ecto.NoResultsError` if the User profile does not exist.

  ## Examples

      iex> get_user_profile!(123)
      %UserProfile{}

      iex> get_user_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_profile!(id), do: Repo.get!(UserProfile, id)

  @doc """
  Gets a single user_profile by the username.

  Returns `nil` if the UserProfile does not exist.

  ## Examples

    iex> get_user_profile_by_username("kint")
    %UserProfile{}

    iex> get_user_profile_by_username("soze")
    nil
  """
  def get_user_profile_by_username(username), do: Repo.get_by(UserProfile, username: username)

  @doc """
  Updates a user_profile.

  ## Examples

      iex> update_user_profile(user_profile, %{field: new_value})
      {:ok, %UserProfile{}}

      iex> update_user_profile(user_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_profile(%UserProfile{} = user_profile, attrs) do
    user_profile
    |> UserProfile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_profile changes.

  ## Examples

      iex> change_user_profile(user_profile)
      %Ecto.Changeset{data: %UserProfile{}}

  """
  def change_user_profile(%UserProfile{} = user_profile, attrs \\ %{}) do
    UserProfile.changeset(user_profile, attrs)
  end
end
