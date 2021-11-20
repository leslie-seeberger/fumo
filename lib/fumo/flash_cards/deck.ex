defmodule Fumo.FlashCards.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  require IEx

  schema "decks" do
    field :description, :string
    field :is_published, :boolean, default: false
    field :title, :string

    field :author_name, :string, virtual: true
    field :card_count, :integer, virtual: true

    belongs_to :user, Fumo.Accounts.User
    belongs_to :category, Fumo.FlashCards.Category
    has_many :cards, Fumo.FlashCards.Card, on_delete: :delete_all
    many_to_many :subscribers, Fumo.Accounts.User, join_through: Fumo.Subscriptions.DeckSubscription

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:title, :description, :is_published, :category_id])
    |> cast_assoc(:cards)
    |> cast_assoc(:subscribers)
    |> validate_required([:title, :category_id])
    |> validate_length(:title, min: 3, max: 30)
    |> validate_publish()
  end

  defp validate_publish(changeset) do
    cards = get_field(changeset, :cards, [])
    cards_change = get_change(changeset, :cards, cards)
    publish = get_field(changeset, :is_published, false)
    publish_change = get_change(changeset, :is_published, is_boolean(publish) and publish)

    cond do
      not is_boolean(publish_change) -> add_error(changeset, :is_published, "Invalid value")
      publish_change and Enum.count(cards_change) < 3 ->
        changeset = put_change(changeset, :is_published, false)
        add_error(changeset, :is_published, "Must have at least 3 cards to publish")
      true -> changeset
    end
  end
end
