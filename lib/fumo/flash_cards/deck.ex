defmodule Fumo.FlashCards.Deck do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:title, :description])
    |> cast_assoc(:cards)
    |> validate_required([:title])
    |> validate_length(:title, min: 3, max: 30)
  end
end
