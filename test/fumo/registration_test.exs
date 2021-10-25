defmodule Fumo.RegistrationTest do
  use Fumo.DataCase
  alias Fumo.Registration

  def unique_username, do: Faker.Internet.user_name()
  def unique_user_email, do: Faker.Internet.email()
  def valid_user_password, do: "Password1234"

  describe "register_user/1" do
    test "requires email, username, and password to be set" do
      {:error, changeset} = Registration.register_user(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"],
               username: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Registration.register_user(%{"email" => "not valid", "password" => "not valid", "username" => "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"],
               username: ["has invalid format"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Registration.register_user(%{"email" => "#{too_long}@email.com", "password" => too_long, "username" => too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 80 character(s)" in errors_on(changeset).password
      assert "should be at most 20 character(s)" in errors_on(changeset).username
    end

    test "registers users with a hashed password" do
      registration_params = params_for(:registration) |> Map.new(fn {k, v} -> {to_string(k), v } end)

      {:ok, %{user: user, profile: profile}} =
        Registration.register_user(registration_params)

      assert user.email == registration_params["email"]
      assert profile.username == registration_params["username"]
      assert user.id == profile.user_id
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end
end
