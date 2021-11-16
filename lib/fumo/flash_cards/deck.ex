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
    has_many :cards, Fumo.FlashCards.Card, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:title, :description, :is_published])
    |> cast_assoc(:cards)
    |> validate_required([:title])
    |> validate_length(:title, min: 3, max: 30)
    |> validate_publish()
  end

  defp validate_publish(changeset) do
    cards = get_field(changeset, :cards)
    cards_change = get_change(changeset, :cards, cards)
    publish = get_field(changeset, :is_published)
    publish_change = get_change(changeset, :is_published, publish)

    # IEx.pry()

    if publish_change and length(cards_change) < 3 do
      changeset = put_change(changeset, :is_published, false)
       add_error(changeset, :is_published, "Must have at least 3 cards to publish")
    else
      changeset
    end
  end
end
