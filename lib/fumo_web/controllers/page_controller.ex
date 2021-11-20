defmodule FumoWeb.PageController do
  use FumoWeb, :controller
  alias Fumo.FlashCards
  alias Fumo.Subscriptions

  def index(conn, _params, nil) do
    render(conn, "landing.html")
  end
  def index(conn, _params, _current_user) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params, current_user) do
    user_decks = FlashCards.list_user_decks(current_user)
    subscribed_decks = list_subscriptions(current_user)

    render(conn, "dashboard.html", user_decks: user_decks, subscriptions: subscribed_decks)
  end

  def action(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
  end

  defp list_subscriptions(current_user) do
      Subscriptions.list_user_subscriptions(current_user)
  end

end
