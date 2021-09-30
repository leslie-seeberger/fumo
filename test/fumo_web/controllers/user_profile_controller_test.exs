defmodule FumoWeb.UserProfileControllerTest do
  use FumoWeb.ConnCase

  alias Fumo.Profiles

  @create_attrs %{bio: "some bio", username: "some username"}
  @update_attrs %{bio: "some updated bio", username: "some updated username"}
  @invalid_attrs %{bio: nil, username: nil}

  def fixture(:user_profile) do
    {:ok, user_profile} = Profiles.create_user_profile(@create_attrs)
    user_profile
  end

  describe "index" do
    test "lists all user_profiles", %{conn: conn} do
      conn = get(conn, Routes.user_profile_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing User profiles"
    end
  end

  describe "new user_profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_profile_path(conn, :new))
      assert html_response(conn, 200) =~ "New User profile"
    end
  end

  describe "create user_profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_profile_path(conn, :create), user_profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_profile_path(conn, :show, id)

      conn = get(conn, Routes.user_profile_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User profile"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_profile_path(conn, :create), user_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User profile"
    end
  end

  describe "edit user_profile" do
    setup [:create_user_profile]

    test "renders form for editing chosen user_profile", %{conn: conn, user_profile: user_profile} do
      conn = get(conn, Routes.user_profile_path(conn, :edit, user_profile))
      assert html_response(conn, 200) =~ "Edit User profile"
    end
  end

  describe "update user_profile" do
    setup [:create_user_profile]

    test "redirects when data is valid", %{conn: conn, user_profile: user_profile} do
      conn = put(conn, Routes.user_profile_path(conn, :update, user_profile), user_profile: @update_attrs)
      assert redirected_to(conn) == Routes.user_profile_path(conn, :show, user_profile)

      conn = get(conn, Routes.user_profile_path(conn, :show, user_profile))
      assert html_response(conn, 200) =~ "some updated bio"
    end

    test "renders errors when data is invalid", %{conn: conn, user_profile: user_profile} do
      conn = put(conn, Routes.user_profile_path(conn, :update, user_profile), user_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User profile"
    end
  end

  describe "delete user_profile" do
    setup [:create_user_profile]

    test "deletes chosen user_profile", %{conn: conn, user_profile: user_profile} do
      conn = delete(conn, Routes.user_profile_path(conn, :delete, user_profile))
      assert redirected_to(conn) == Routes.user_profile_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_profile_path(conn, :show, user_profile))
      end
    end
  end

  defp create_user_profile(_) do
    user_profile = fixture(:user_profile)
    %{user_profile: user_profile}
  end
end
