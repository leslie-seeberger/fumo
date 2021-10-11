defmodule Fumo.FlashCards.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decks" do
    field :description, :string
    field :is_published, :boolean, default: false
    field :title, :string

    belongs_to :user, Fumo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
    |> validate_length(:title, min: 3, max: 30)
  end
end
