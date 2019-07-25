# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sac_sac_mate,
  ecto_repos: [SacSacMate.Repo]

# Configures the endpoint
config :sac_sac_mate, SacSacMateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SwnwVGWTIo4K4i+8o4Q4S9lGfcuhZ4A5lJnqBBSFyO0hz2HZmayWnUVJADJcAqQu",
  render_errors: [view: SacSacMateWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SacSacMate.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
