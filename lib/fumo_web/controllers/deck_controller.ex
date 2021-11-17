defmodule FumoWeb.DeckController do
  use FumoWeb, :controller

  alias Fumo.FlashCards
  alias Fumo.FlashCards.Deck
  alias Fumo.Authorizer

  plug :authorize_user when action in [:edit, :delete, :update]

  def index(conn, _params, _current_user) do
    decks = FlashCards.list_decks()
    render(conn, "index.html", decks: decks)
  end

  def new(conn, _params, current_user) do
    unless is_nil(current_user) do
      changeset = FlashCards.change_deck(%Deck{})
      render(conn, "new.html", changeset: changeset)
    else
      conn
      |> put_flash(:error, "Please log in to create a deck.")
      |> redirect(to: "/")
  end
  end

  def create(conn, %{"deck" => deck_params}, current_user) do
    case FlashCards.create_deck(current_user, deck_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck created successfully.")
        |> redirect(to: Routes.deck_path(conn, :show, deck))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    deck = FlashCards.get_deck!(id, current_user)
    render(conn, "show.html", deck: deck)
  end

  def edit(conn, %{"id" => id}, current_user) do
    deck = FlashCards.get_user_deck!(current_user, id)
    changeset = FlashCards.change_deck(deck)
    render(conn, "edit.html", deck: deck, changeset: changeset)
  end

  def update(conn, %{"id" => id, "deck" => deck_params}, current_user) do
    deck = FlashCards.get_user_deck!(current_user, id)

    case FlashCards.update_deck(deck, deck_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck updated successfully.")
        |> redirect(to: Routes.deck_path(conn, :show, deck))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", deck: deck, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    deck = FlashCards.get_user_deck!(current_user, id)
    {:ok, _deck} = FlashCards.delete_deck(deck)

    conn
    |> put_flash(:info, "Deck deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :dashboard))
  end

  def action(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, current_user])
  end

  defp authorize_user(conn, _opts) do
    deck_id = conn.params["id"]
    with {:ok, user} <- Map.fetch(conn.assigns, :current_user),
      deck <- FlashCards.get_deck!(deck_id, user),
      true <- Authorizer.can_manage?(user, deck) do
        conn
      else
        _ ->
          conn
          |> put_flash(:error, "You are not authorized to do that.")
          |> redirect(to: "/")
          |> halt()
      end

  end
end
