defmodule FumoWeb.UserProfileController do
  use FumoWeb, :controller

  alias Fumo.Profiles
  alias Fumo.Profiles.UserProfile
  alias Fumo.FlashCards

  def show(conn, %{"username" => username}) do
    case Profiles.get_user_profile_by_username(username) do
      user_profile when is_struct(user_profile, UserProfile) ->
        decks = FlashCards.list_user_decks(user_profile.user_id)
        render(conn, "show.html", user_profile: user_profile, decks: decks)
      _ -> conn
        |> put_flash(:error, "Profile not found")
        |> redirect(to: "/")
    end
  end

end
