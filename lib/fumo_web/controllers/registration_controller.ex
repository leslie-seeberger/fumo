defmodule FumoWeb.RegistrationController do
  use FumoWeb, :controller
  alias Fumo.{Registration, Repo, Accounts}
  alias FumoWeb.UserAuth

  require IEx

  def new(conn, _params) do
    changeset = Registration.changeset(%Registration{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"registration" => registration_params}) do
    changeset = Registration.changeset(%Registration{}, registration_params)
    if changeset.valid? do
      result = Repo.transaction(Registration.to_multi(registration_params))
      case result do
      {:ok, %{user: user}} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, _failed_operation, failed_value, _changes} ->
        changeset = copy_errors(failed_value, changeset)
        render(conn, :new, changeset: %{changeset | action: :insert})
      end
    else
      render(conn, :new, changeset: %{changeset | action: :insert})
    end
  end

  defp copy_errors(from, to) do
    Enum.reduce(from.errors, to, fn {field, {msg, additional}}, acc ->
      Ecto.Changeset.add_error(acc, field, msg, additional)
    end)
  end
end
