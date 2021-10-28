defmodule FumoWeb.DeckView do
  use FumoWeb, :view

  def to_json(struct, fields) do
    Map.take(struct, fields)
    |> Jason.encode!()
  end
end
