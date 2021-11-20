defmodule Fumo.SubscriptionsTest do
  use Fumo.DataCase

  alias Fumo.Subscriptions

  describe "deck_subscriptions" do
    alias Fumo.Subscriptions.DeckSubscription

    def deck_subscription_fixture(attrs \\ %{}) do
      insert(:deck_subscription, attrs)
      |> forget(:user)
      |> forget(:deck)
    end

    test "list_deck_subscriptions/0 returns all deck_subscriptions" do
      deck_subscription = deck_subscription_fixture()
      assert Subscriptions.list_deck_subscriptions() == [deck_subscription]
    end

    test "get_deck_subscription!/1 returns the deck_subscription with given id" do
      deck_subscription = deck_subscription_fixture()
      assert Subscriptions.get_deck_subscription!(deck_id: deck_subscription.deck_id,
        user_id: deck_subscription.user_id) == deck_subscription
    end

    test "create_deck_subscription/1 with valid data creates a deck_subscription" do
      user = insert(:user)
      deck = insert(:deck)

      assert {:ok, %DeckSubscription{} = deck_subscription} = Subscriptions.create_deck_subscription(%{user_id: user.id, deck_id: deck.id})
      assert deck_subscription.deck_id == deck.id
      assert deck_subscription.user_id == user.id
    end

    test "create_deck_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_deck_subscription(%{})
    end

    test "create_deck_subscription/1 are unique per user and deck" do
      deck_subscription = deck_subscription_fixture()

      assert_raise Ecto.ConstraintError, fn ->
        Subscriptions.create_deck_subscription(%{deck_id: deck_subscription.deck_id, user_id: deck_subscription.user_id}) end
    end

    test "delete_deck_subscription/1 deletes the deck_subscription" do
      deck_subscription = deck_subscription_fixture()
      assert {:ok, %DeckSubscription{}} = Subscriptions.delete_deck_subscription(deck_subscription)
      assert_raise Ecto.NoResultsError, fn ->
        Subscriptions.get_deck_subscription!(deck_id: deck_subscription.deck_id, user_id: deck_subscription.user_id) end
    end

    test "change_deck_subscription/1 returns a deck_subscription changeset" do
      deck_subscription = deck_subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_deck_subscription(deck_subscription)
    end
  end
end
