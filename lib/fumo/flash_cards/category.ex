defmodule Fumo.FlashCards.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_length(:name, min: 3, max: 30)
    |> validate_required([:name])
  end
end
