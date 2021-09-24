defmodule Fumo.Repo do
  use Ecto.Repo,
    otp_app: :fumo,
    adapter: Ecto.Adapters.Postgres
end
