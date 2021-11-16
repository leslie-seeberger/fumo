defmodule FumoWeb.DeckView do
  use FumoWeb, :view

  def to_json(struct, fields) do
    Map.take(struct, fields)
    |> Jason.encode!()
  end

  def disable_publish(changeset) do
    cards = changeset.data.cards
    temp_cards = Map.get(changeset.changes, :cards, [])
    Enum.count(cards ++ temp_cards) < 3
  end
end
