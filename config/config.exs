# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vr,
  ecto_repos: [Vr.Repo]

# Configures the endpoint
config :vr, Vr.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "24y7TB8rOGV5jjuxqeSqZnafUsOtQZWNPNbn1poNJums7U0w/CoNawx9s5nxDJxF",
  render_errors: [view: Vr.ErrorView, accepts: ~w(json)],
  pubsub: [name: Vr.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :ex_admin,
  repo: Vr.Repo,
  module: Vr,
  modules: [
    Vr.ExAdmin.Dashboard,
    Vr.ExAdmin.Post,
    Vr.ExAdmin.User,
    Vr.ExAdmin.Highlight
  ]
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

