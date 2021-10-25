defmodule FumoWeb.UserProfileControllerTest do
  use FumoWeb.ConnCase

  alias Fumo.Profiles.UserProfile

  describe "show" do
    setup [:create_user_profile]

    test "shows user profile when username is found", %{conn: conn, user_profile: user_profile} do
      conn = get(conn, Routes.user_profile_path(conn, :show, user_profile))
      assert html_response(conn, 200) =~ user_profile.username
    end

    test "redirects to root path when username is not found", %{conn: conn} do
      conn = get(conn, Routes.user_profile_path(conn, :show, %UserProfile{username: "err"}))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  defp create_user_profile(_) do
    user_profile = insert(:user).profile

    %{user_profile: user_profile}
  end
end
