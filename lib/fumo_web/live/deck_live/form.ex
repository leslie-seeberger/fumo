defmodule FumoWeb.DeckLive.Form do
  use FumoWeb, :live_view

  alias Fumo.FlashCards
  alias Fumo.FlashCards.{Deck, Card}

  @impl true
  def mount(_params, %{"action" => action } = session, socket) do
    deck = get_deck(session)

    changeset =
      FlashCards.change_deck(deck)
      |> Ecto.Changeset.put_assoc(:cards, deck.cards)

    category_options = FlashCards.list_categories()

    assigns = [
      conn: socket,
      changeset: changeset,
      deck: deck,
      action: action,
      category_options: category_options
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("add-card", _params, socket) do
    deck_id = socket.assigns.deck.id
    cards =
      Map.get(socket.assigns.changeset.changes, :cards, socket.assigns.deck.cards)
      |> Enum.concat([
        FlashCards.change_card(%Card{temp_id: get_temp_id(), deck_id: deck_id})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cards, cards)

      {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-card", %{"remove" => id}, socket) do
    cards =
      socket.assigns.changeset.changes.cards
      |> Enum.reject(fn %{data: card} ->
        card.temp_id == id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cards, cards)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("preview", _params, socket) do
     cards =
      Map.get(socket.assigns.changeset.changes, :cards, socket.assigns.deck.cards)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cards, cards)

      {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns), do: FumoWeb.DeckView.render("form.html", assigns)

  defp get_deck(%{"id" => deck_id, "current_user" => current_user}) do
    FlashCards.get_deck!(deck_id, current_user)
  end
  defp get_deck(_), do: %Deck{cards: []}

  defp get_temp_id() do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64()
    |> binary_part(0,5)
  end
end
