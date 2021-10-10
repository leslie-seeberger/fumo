defmodule FumoWeb.RegistrationController do
  use FumoWeb, :controller
  alias Fumo.{UserRegistration, Accounts, Registration}
  alias FumoWeb.UserAuth

  def new(conn, _params) do
    changeset = UserRegistration.changeset(%UserRegistration{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user_registration" => registration_params}) do
      case Registration.register_user(registration_params) do
        {:ok, %{user: user}} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &Routes.user_confirmation_url(conn, :confirm, &1)
            )

            conn
            |> put_flash(:info, "User created successfully.")
            |> UserAuth.log_in_user(user)
        {:error, changeset} ->
          render(conn, :new, changeset: %{changeset | action: :insert})
      end
  end
end
