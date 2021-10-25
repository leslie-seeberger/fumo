defmodule Fumo.FlashCards do
  @moduledoc """
  The FlashCards context.
  """

  import Ecto.Query, warn: false
  alias Fumo.Repo

  alias Fumo.FlashCards.Deck
  alias Fumo.Accounts.User
  alias Fumo.Profiles.UserProfile

  @doc """
  Returns the list of published decks.

  ## Examples

      iex> list_decks()
      [%Deck{}, ...]

  """
  def list_decks do
    Deck
    |> where([d], d.is_published)
    |> get_author_name()
    |> Repo.all()
  end

  @doc """
  Returns a list of a user's decks.

  ## Examples

    iex> list_user_decks(%User{})
    [%Deck{}, ...]
  """
  def list_user_decks(%User{} = user) do
    Deck
    |> where_owner(user)
    |> get_author_name()
    |> Repo.all()
  end

  def list_user_decks(user_id) do
    list_user_decks(%User{id: user_id})
  end

  @doc """
  Gets a single deck.

  Raises `Ecto.NoResultsError` if the Deck does not exist.

  ## Examples

      iex> get_deck!(123)
      %Deck{}

      iex> get_deck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deck!(id, %User{} = user) do
    Deck
    |> where_published_or_owner(user)
    |> get_author_name()
    |> preload(:cards)
    |> Repo.get!(id)
  end



  @doc """
  Gets a single deck associated with a user

  ## Examples

    iex> get_user_deck!(%User{}, 123)
    %Deck{}

    iex> get_user_deck!(%User{}, 456)
    ** (Ecto.NoResultsError)
  """
  def get_user_deck!(%User{} = user, id) do
    Deck
    |> where_owner(user)
    |> get_author_name()
    |> preload(:cards)
    |> Repo.get!(id)
  end

  @doc """
  Creates a deck.

  ## Examples

      iex> create_deck(%{field: value})
      {:ok, %Deck{}}

      iex> create_deck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deck(%User{} = user, attrs \\ %{}) do
    %Deck{}
    |> Deck.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a deck.

  ## Examples

      iex> update_deck(deck, %{field: new_value})
      {:ok, %Deck{}}

      iex> update_deck(deck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deck(%Deck{} = deck, attrs) do
    deck
    |> Deck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deck.

  ## Examples

      iex> delete_deck(deck)
      {:ok, %Deck{}}

      iex> delete_deck(deck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deck(%Deck{} = deck) do
    Repo.delete(deck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deck changes.

  ## Examples

      iex> change_deck(deck)
      %Ecto.Changeset{data: %Deck{}}

  """
  def change_deck(%Deck{} = deck, attrs \\ %{}) do
    Deck.changeset(deck, attrs)
  end

  defp where_owner(query, %User{id: user_id}) do
    query
    |> where([d], d.user_id == ^user_id)
  end

  defp where_published_or_owner(query,%User{id: user_id}) do
    query |>
    where([d], d.is_published or d.user_id == ^user_id)
  end

  defp where_published_or_owner(query, _user) do
    query |> where([d], d.is_published)
  end

  defp get_author_name(query) do
    query
    |> join(:left, [d], p in UserProfile, on: d.user_id == p.user_id)
    |> select_merge([_d, p], %{author_name: p.username})
  end

  alias Fumo.FlashCards.Card

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end
end
