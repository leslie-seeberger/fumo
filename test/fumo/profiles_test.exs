defmodule Fumo.ProfilesTest do
  use Fumo.DataCase

  alias Fumo.Profiles
  import Fumo.RegistrationFixtures

  describe "user_profiles" do
    alias Fumo.Profiles.UserProfile

    @update_attrs %{bio: "some updated bio", username: Faker.Internet.user_name()}
    @invalid_attrs %{bio: nil, username: nil}

    setup do
      registration_fixture()
    end

    test "get_user_profile!/1 returns the user_profile with given id", %{profile: user_profile}do
      assert Profiles.get_user_profile!(user_profile.id) == user_profile
    end

    test "get_user_profile_by_username/1 returns the user_profile with given username", %{profile: user_profile}  do
      %{username: username} = user_profile
      assert Profiles.get_user_profile_by_username(username) == user_profile
    end

    test "get_user_profile_by_username/1 returns nil if profile with username not found" do
      assert is_nil(Profiles.get_user_profile_by_username("nil"))
    end

    test "update_user_profile/2 with valid data updates the user_profile", %{profile: user_profile} do
      assert {:ok, %UserProfile{} = user_profile} = Profiles.update_user_profile(user_profile, @update_attrs)
      assert user_profile.bio == @update_attrs.bio
      assert user_profile.username == @update_attrs.username
    end

    test "update_user_profile/2 with invalid data returns error changeset" , %{profile: user_profile} do
      assert {:error, %Ecto.Changeset{}} = Profiles.update_user_profile(user_profile, @invalid_attrs)
      assert user_profile == Profiles.get_user_profile!(user_profile.id)
    end

  end
end
