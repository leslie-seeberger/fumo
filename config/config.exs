# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fumo,
  ecto_repos: [Fumo.Repo]

# Configures the endpoint
config :fumo, FumoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Cs1JR74iADZlzYZNVwrBqxNoAXDobUf9FfpVt5gLaS1sDk1v2GAp/majjim5Xcc7",
  render_errors: [view: FumoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fumo.PubSub,
  live_view: [signing_salt: "eIv3sHRB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
