defmodule Fumo.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false
  alias Fumo.Repo

  alias Fumo.Subscriptions.DeckSubscription
  alias Fumo.Accounts.User
  alias Fumo.Profiles.UserProfile
  alias Fumo.FlashCards.{Card, Deck}
  @doc """
  Returns the list of deck_subscriptions.

  ## Examples

      iex> list_deck_subscriptions()
      [%DeckSubscription{}, ...]

  """
  def list_deck_subscriptions do
    Repo.all(DeckSubscription)
  end

  @doc """
  Returns the list of deck_subscriptions associated
  with %User{}

  ## Examples

    iex> list_user_subscriptions(bob)
    [%Deck{}, ...]
  """
  def list_user_subscriptions(%User{} = user) do
    decks = DeckSubscription
    |> where([ds], ds.user_id == ^user.id)
    |> join(:left, [ds], d in assoc(ds, :deck) )
    |> join(:left, [_ds, d], ca in assoc(d, :category))
    |> select([_ds, d, ca], %Deck{d | category: ca})

    decks
    |> join(:left, [_ds, d], p in UserProfile, on: d.user_id == p.user_id)
    |> join(:left, [_ds, d, _ca], c in Card, on: d.id == c.deck_id)
    |> group_by([_ds, d, ca, u, _c], [d.id, u.username, ca.id])
    |> select_merge([_ds, _d, ca, u, c], %{card_count: count(c.id), author_name: u.username, category: ca})
    |> Repo.all()
  end

  @doc """
  Gets a single deck_subscription.

  Raises `Ecto.NoResultsError` if the Deck subscription does not exist.

  ## Examples

      iex> get_deck_subscription!(123)
      %DeckSubscription{}

      iex> get_deck_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deck_subscription!(deck_id: deck_id, user_id: user_id), do: Repo.get_by!(DeckSubscription, [deck_id: deck_id, user_id: user_id])

  @doc """
  Creates a deck_subscription.

  ## Examples

      iex> create_deck_subscription(%{field: value})
      {:ok, %DeckSubscription{}}

      iex> create_deck_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deck_subscription(attrs \\ %{}) do
    %DeckSubscription{}
    |> DeckSubscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a deck_subscription.

  ## Examples

      iex> delete_deck_subscription(deck_subscription)
      {:ok, %DeckSubscription{}}

      iex> delete_deck_subscription(deck_subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deck_subscription(%DeckSubscription{} = deck_subscription) do
    Repo.delete(deck_subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deck_subscription changes.

  ## Examples

      iex> change_deck_subscription(deck_subscription)
      %Ecto.Changeset{data: %DeckSubscription{}}

  """
  def change_deck_subscription(%DeckSubscription{} = deck_subscription, attrs \\ %{}) do
    DeckSubscription.changeset(deck_subscription, attrs)
  end
end
