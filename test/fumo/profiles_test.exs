defmodule Fumo.ProfilesTest do
  use Fumo.DataCase

  alias Fumo.Profiles

  describe "user_profiles" do
    alias Fumo.Profiles.UserProfile

    @valid_attrs %{bio: "some bio", username: "some username"}
    @update_attrs %{bio: "some updated bio", username: "some updated username"}
    @invalid_attrs %{bio: nil, username: nil}

    def user_profile_fixture(attrs \\ %{}) do
      {:ok, user_profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Profiles.create_user_profile()

      user_profile
    end

    test "list_user_profiles/0 returns all user_profiles" do
      user_profile = user_profile_fixture()
      assert Profiles.list_user_profiles() == [user_profile]
    end

    test "get_user_profile!/1 returns the user_profile with given id" do
      user_profile = user_profile_fixture()
      assert Profiles.get_user_profile!(user_profile.id) == user_profile
    end

    test "create_user_profile/1 with valid data creates a user_profile" do
      assert {:ok, %UserProfile{} = user_profile} = Profiles.create_user_profile(@valid_attrs)
      assert user_profile.bio == "some bio"
      assert user_profile.username == "some username"
    end

    test "create_user_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_user_profile(@invalid_attrs)
    end

    test "update_user_profile/2 with valid data updates the user_profile" do
      user_profile = user_profile_fixture()
      assert {:ok, %UserProfile{} = user_profile} = Profiles.update_user_profile(user_profile, @update_attrs)
      assert user_profile.bio == "some updated bio"
      assert user_profile.username == "some updated username"
    end

    test "update_user_profile/2 with invalid data returns error changeset" do
      user_profile = user_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_user_profile(user_profile, @invalid_attrs)
      assert user_profile == Profiles.get_user_profile!(user_profile.id)
    end

    test "delete_user_profile/1 deletes the user_profile" do
      user_profile = user_profile_fixture()
      assert {:ok, %UserProfile{}} = Profiles.delete_user_profile(user_profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_user_profile!(user_profile.id) end
    end

    test "change_user_profile/1 returns a user_profile changeset" do
      user_profile = user_profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_user_profile(user_profile)
    end
  end
end
