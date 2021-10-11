defmodule Fumo.FlashCardsFixtures do
  alias Fumo.FlashCards
  alias Fumo.Accounts.User

  def valid_deck_title() do
    Faker.Lorem.characters(3..20)
    |> to_string()
  end
  def valid_deck_description, do: Faker.Lorem.paragraph()

  def valid_deck_attributes(attrs \\ %{}) do
    Map.merge(%{
      "title" => valid_deck_title(),
      "description" => valid_deck_description()
    }, attrs)
  end

  def deck_fixture(%User{} = user, attrs \\ %{}) do
      attrs = valid_deck_attributes(attrs)
      {:ok, deck} = FlashCards.create_deck(user, attrs)
      deck
  end
end
