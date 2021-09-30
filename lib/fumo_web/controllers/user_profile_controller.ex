defmodule FumoWeb.UserProfileController do
  use FumoWeb, :controller

  alias Fumo.Profiles

  def show(conn, %{"username" => username}) do
    # case Profiles.get_user_profile_by_username(username) do
    #   user_profile = %UserProfile{} -> render(conn, "show.html", user_profile: user_profile)
    #   _ -> conn
    #     |> put_flash(:error, "Profile not found")
    #     |> redirect(to: "/")
    # end

    if user_profile = Profiles.get_user_profile_by_username(username) do
      render(conn, "show.html", user_profile: user_profile)
    else
      conn
        |> put_flash(:error, "Profile not found")
        |> redirect(to: "/")
    end
  end

end
