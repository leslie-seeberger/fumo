defmodule Fumo.Registration do
  alias Fumo.Repo
  alias Fumo.UserRegistration

  def register_user(attrs \\ %{}) do
    changeset = UserRegistration.changeset(%UserRegistration{}, attrs)
    if changeset.valid? do
      case Repo.transaction(UserRegistration.to_multi(attrs)) do
      {:ok, %{user: user, profile: profile}} -> {:ok, %{user: user, profile: profile}}
      {:error, _failed_operation, failed_value, _changes} ->
        {:error, copy_errors(failed_value.errors, changeset)}
      end
    else
      {:error, changeset}
    end
  end

  defp copy_errors(from, to) do
    Enum.reduce(from, to, fn {field, {msg, additional}}, acc ->
      Ecto.Changeset.add_error(acc, field, msg, additional)
    end)
  end
end
