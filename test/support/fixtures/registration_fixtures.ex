defmodule Fumo.RegistrationFixtures do
  alias Fumo.Registration

  def unique_username, do: Faker.Internet.user_name()
  def unique_user_email, do: Faker.Internet.email()
  def valid_user_password, do: "Password1234"

  def valid_registration_attributes(attrs \\ %{}) do
    Map.merge(%{
       "email" => unique_user_email(),
      "username" => unique_username(),
      "password" => valid_user_password()
    }, attrs)
  end

  def registration_fixture(attrs \\ %{}) do
    {:ok, fixture} =
      attrs
      |> valid_registration_attributes()
      |> Registration.register_user()

      fixture
  end
end
