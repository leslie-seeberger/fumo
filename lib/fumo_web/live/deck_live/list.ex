defmodule FumoWeb.DeckLive.List do
  use FumoWeb, :live_view
  alias Fumo.Subscriptions
  alias Fumo.Subscriptions.DeckSubscription

  @impl true
  def mount(_params, %{"current_user" => current_user, "decks" => decks }, socket) do
    # decks = FlashCards.list_decks()

    # socket = assign(socket, decks: decks)
    assigns = [
      decks: decks,
      current_user: current_user
    ]
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("subscribe", %{"deck_id" => deck_id, "user_id" => user_id}, socket) do
    Subscriptions.create_deck_subscription(%{deck_id: deck_id, user_id: user_id})
    {:noreply, socket}
  end

  def handle_event("unsubscribe", %{"deck_id" => deck_id, "user_id" => user_id}, socket) do
    case Subscriptions.delete_deck_subscription(%DeckSubscription{deck_id: deck_id, user_id: user_id}) do
      {:ok, _} -> :ok
      {:error, error} -> IO.inspect(error)
    end
    {:noreply, socket}
  end

end
