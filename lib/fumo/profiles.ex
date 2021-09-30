defmodule Fumo.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Fumo.Repo

  alias Fumo.Profiles.UserProfile
  alias Fumo.Accounts.User

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

  def get_user_profile_by_username(username), do: Repo.get_by(UserProfile, username: username)

  @doc """
  Gets a single user_profile by the user's id.
  Raises `Ecto.NoResultsError` if the UserProfile does not exist.

  ## Examples

      iex > get_user_profile_by_userid!(123)
      %UserProfile{}

      iex> get_user_profile_by_userid!(456)
      ** (Ecto.NoResultsError)
  """
  def get_user_profile_by_userid!(user_id) do
    Repo.get_by!(UserProfile, user_id: user_id)
  end

  @doc """
  Creates a user_profile.

  ## Examples

      iex> create_user_profile(%{field: value})
      {:ok, %UserProfile{}}

      iex> create_user_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_profile(attrs \\ %{}) do
    %UserProfile{}
    |> UserProfile.changeset(attrs)
    |> Repo.insert()
  end

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

  def update_user_profile(%User{id: user_id}, attrs) do
    user_profile = get_user_profile_by_userid!(user_id)
    update_user_profile(user_profile, attrs)
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

  def change_user_profile_by_user(%User{id: user_id}, attrs \\ %{} ) do
    get_user_profile_by_userid!(user_id)
    |> change_user_profile(attrs)
  end
end
