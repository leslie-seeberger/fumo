defmodule Fumo.Factory do
  use ExMachina.Ecto, repo: Fumo.Repo

  alias Fumo.FlashCards.{Deck, Card, Category}
  alias Fumo.Accounts.User
  alias Fumo.Profiles.UserProfile
  alias Fumo.UserRegistration
  alias Fumo.Subscriptions.DeckSubscription

  def user_factory() do
    %User{
      email: Faker.Internet.email(),
      password: "Password1234",
      hashed_password: "Password1234",
      profile: build(:profile)
    }
  end

  def registration_factory() do
    %UserRegistration{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: "Password1234"
    }
  end

  def profile_factory() do
    %UserProfile{
      username: Faker.Internet.user_name(),
      bio: Faker.Lorem.paragraph(),
    }
  end

  def deck_factory() do
    %Deck{
      title: ranged_string_length(3..20),
      is_published: false,
      description: Faker.Lorem.paragraph(),
      user: build(:user),
      cards: build_list(3, :card),
      category: build(:category)
    }
  end

  def with_author_name(%Deck{user: user} = deck) do
    %Deck{ deck | author_name: user.profile.username}
  end

  def with_card_count(%Deck{cards: cards} = deck) do
    %Deck{deck | card_count: Enum.count(cards)}
  end

  def card_factory() do
    %Card{
      front: Faker.Lorem.sentence(1..2),
      back: Faker.Lorem.sentence(1..2),
    }
  end

  def category_factory() do
    %Category{
      name: Faker.Lorem.word()
    }
  end

  def deck_subscription_factory() do
    %DeckSubscription{
      user: build(:user),
      deck: build(:deck)
    }
  end

  defp ranged_string_length(%Range{} = range) do
    Faker.Lorem.characters(range)
    |> to_string()
  end

  def forget(struct, field, cardinality \\ :one) do
    %{struct |
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end
end
