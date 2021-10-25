defmodule Fumo.RegistrationHelper do
  import Fumo.Factory

  def register_user do
    {:ok, fixture} = params_for(:registration)
    |> Map.new(fn {k, v} -> {to_string(k), v } end)
    |> Fumo.Registration.register_user()

    fixture
  end
end
