defmodule Fumo.FlashCardsTest do
  use Fumo.DataCase

  alias Fumo.FlashCards
  alias Fumo.FlashCards.Deck

  describe "decks" do

    @valid_attrs %{description: "some description", is_published: false, title: "some title"}
    @update_attrs %{description: "some updated description", is_published: true, title: "some updated title"}
    @invalid_attrs %{description: nil, is_published: false, title: nil}

    setup do
      user = insert(:user)
      deck = insert(:deck, user: user)

      cards = build_list(3, :card)
      insert_list(5, :deck, %{is_published: true, cards: cards})

      %{user: user, deck: deck}
    end

    defp deck_with_author(user, opts \\ %{}) do
      opts = Map.put(opts, :user, user)
      build(:deck, opts)
        |> with_author_name()
        |> insert()
        |> forget(:user)
    end

    test "list_decks/0 returns all published decks" do
      decks = FlashCards.list_decks()
      assert Enum.count(decks) == 5
    end

    test "list_user_decks/1 returns user's decks" do
      user = insert(:user)
      deck = deck_with_author(user) |> with_card_count() |> forget(:cards, :many)
      decks = FlashCards.list_user_decks(user)

      assert  decks == [deck]
      assert Enum.all?(decks, fn d -> d.user_id == user.id end)
    end

    test "list_user_decks/1 does not return decks belonging to another user" do
      user = insert(:user)
      decks = FlashCards.list_user_decks(user)

      assert Enum.empty?(decks)
    end

    test "get_deck!/1 returns the deck with given id", %{user: user} do
      deck = deck_with_author(user)

      assert FlashCards.get_deck!(deck.id, user) == deck
    end

    test "create_deck/1 with valid data creates a deck", %{user: user} do
      assert {:ok, %Deck{} = deck} = FlashCards.create_deck(user, @valid_attrs)
      assert deck.description == "some description"
      assert deck.is_published == false
      assert deck.title == "some title"
    end

    test "create_deck/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = FlashCards.create_deck(user, @invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck", %{deck: deck} do
      assert {:ok, %Deck{} = deck} = FlashCards.update_deck(deck, @update_attrs)
      assert deck.description == "some updated description"
      assert deck.is_published == true
      assert deck.title == "some updated title"
    end

    test "update_deck/2 with is_published = true only works under valid conditions" do
      user = insert(:user)
      deck = deck_with_author(user, %{cards: build_list(2, :card)})

      assert deck == FlashCards.get_deck!(deck.id, user)
      assert {:error, %Ecto.Changeset{}} = FlashCards.update_deck(deck, %{is_published: true})

    end

    test "update_deck/2 with invalid data returns error changeset" do
      user = insert(:user)
      deck = deck_with_author(user)

      assert {:error, %Ecto.Changeset{}} = FlashCards.update_deck(deck, @invalid_attrs)
      assert deck == FlashCards.get_deck!(deck.id, user)
    end

    test "delete_deck/1 deletes the deck", %{deck: deck, user: user} do
      assert {:ok, %Deck{}} = FlashCards.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> FlashCards.get_deck!(deck.id, user) end
    end

    test "change_deck/1 returns a deck changeset", %{deck: deck} do
      assert %Ecto.Changeset{} = FlashCards.change_deck(deck)
    end
  end

  describe "cards" do
    alias Fumo.FlashCards.Card
    alias Fumo.Repo

    @valid_attrs %{back: "some back", front: "some front"}
    @update_attrs %{back: "some updated back", front: "some updated front"}
    @invalid_attrs %{back: nil, front: nil}

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = FlashCards.create_card(@valid_attrs)
      assert card.back == @valid_attrs.back
      assert card.front == @valid_attrs.front
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FlashCards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = insert(:card)
      assert {:ok, %Card{} = card} = FlashCards.update_card(card, @update_attrs)
      assert card.back == "some updated back"
      assert card.front == "some updated front"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = insert(:card)
      assert {:error, %Ecto.Changeset{}} = FlashCards.update_card(card, @invalid_attrs)
      assert card == Repo.get!(Card, card.id)
    end

    test "delete_card/1 deletes the card" do
      card = insert(:card)
      assert {:ok, %Card{}} = FlashCards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn ->
        Repo.get!(Card, card.id)
      end
    end

    test "change_card/1 returns a card changeset" do
      card = insert(:card)
      assert %Ecto.Changeset{} = FlashCards.change_card(card)
    end
  end
end
