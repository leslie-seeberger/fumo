defmodule Fumo.Subscriptions.DeckSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "deck_subscription" do
    belongs_to :user, Fumo.Accounts.User, primary_key: true
    belongs_to :deck, Fumo.FlashCards.Deck, primary_key: true
  end

  @doc false
  def changeset(deck_subscription, attrs) do
    deck_subscription
    |> cast(attrs, [:deck_id, :user_id])
    |> validate_required([:deck_id, :user_id])
  end
end
