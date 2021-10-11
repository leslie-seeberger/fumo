defmodule Fumo.FlashCardsTest do
  use Fumo.DataCase

  alias Fumo.FlashCards
  alias Fumo.RegistrationFixtures
  alias Fumo.FlashCardsFixtures

  describe "unpublished decks" do
    alias Fumo.FlashCards.Deck

    @valid_attrs %{description: "some description", is_published: false, title: "some title"}
    @update_attrs %{description: "some updated description", is_published: false, title: "some updated title"}
    @invalid_attrs %{description: nil, is_published: nil, title: nil}

    setup do
      %{user: user} = RegistrationFixtures.registration_fixture()
      %{user: owner} = RegistrationFixtures.registration_fixture()
      deck = FlashCardsFixtures.deck_fixture(owner)

      %{user: user, deck: deck, owner: owner}
    end

    test "list_decks/0 returns all published decks" do
      decks = FlashCards.list_decks()
      assert  decks == []
    end

    test "list_user_decks/1 returns user's decks", %{owner: user, deck: deck} do
      decks = FlashCards.list_user_decks(user)

      assert  decks == [deck]
      assert Enum.all?(decks, fn d -> d.user_id == user.id end)
    end

    test "list_user_decks/1 does not return decks belonging to another user", %{user: user} do
      decks = FlashCards.list_user_decks(user)

      assert Enum.empty?(decks)
    end

    test "get_deck!/1 returns the deck with given id", %{deck: deck, owner: user} do
      assert FlashCards.get_deck!(deck.id, user) == deck
    end

    test "create_deck/1 with valid data creates a deck", %{owner: user} do
      assert {:ok, %Deck{} = deck} = FlashCards.create_deck(user, @valid_attrs)
      assert deck.description == "some description"
      assert deck.is_published == false
      assert deck.title == "some title"
    end

    test "create_deck/1 with invalid data returns error changeset", %{owner: user} do
      assert {:error, %Ecto.Changeset{}} = FlashCards.create_deck(user, @invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck", %{deck: deck} do
      assert {:ok, %Deck{} = deck} = FlashCards.update_deck(deck, @update_attrs)
      assert deck.description == "some updated description"
      assert deck.is_published == false
      assert deck.title == "some updated title"
    end

    test "update_deck/2 with invalid data returns error changeset", %{deck: deck, owner: user} do
      assert {:error, %Ecto.Changeset{}} = FlashCards.update_deck(deck, @invalid_attrs)
      assert deck == FlashCards.get_deck!(deck.id, user)
    end

    test "delete_deck/1 deletes the deck", %{deck: deck, owner: user} do
      assert {:ok, %Deck{}} = FlashCards.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> FlashCards.get_deck!(deck.id, user) end
    end

    test "change_deck/1 returns a deck changeset", %{deck: deck} do
      assert %Ecto.Changeset{} = FlashCards.change_deck(deck)
    end
  end
end
