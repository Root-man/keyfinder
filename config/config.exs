# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :keyfinder,
  ecto_repos: [Keyfinder.Repo],
  load_from_db: true

# Configures the endpoint
config :keyfinder, KeyfinderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hBHTXckEY38TJZ+S+Rw0oJajw8DsWlURgDc1uNEerlM/1z1GiHXLXkbmuZaMlnWp",
  render_errors: [view: KeyfinderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Keyfinder.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
