defmodule Fumo.FlashCards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :back, :string
    field :front, :string

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    belongs_to :deck, Fumo.FlashCards.Deck

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> Map.put(:temp_id, (card.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:front, :back, :delete])
    |> validate_required([:front, :back])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
