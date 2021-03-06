use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :vr, Vr.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
    cd: Path.expand("../", __DIR__)]]
  # watchers: []

config :vr, Vr.Gettext, default_locale: "zh"
# Do not include metadata nor timestamps in development logs
config :logger, 
  #:console, 
  backends: [:console, {LoggerFileBackend, :info_log}, {LoggerFileBackend, :error_log}],
  format: "[$level] $message\n"

config :logger, :info_log,
  truncate: 5240880,
  path: "log/info.log",
  level: :info
config :logger, :error_log,
  truncate: 5240880,
  path: "log/error.log",
  level: :error

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :vr, Vr.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "22143521",
  database: "vr_dev",
  hostname: "localhost",
  pool_size: 10
config :vr, Vr.Assets,
  host_url: "http://localhost:8080",
  asset_url: "http://localhost:3000"
import_config "dev.secret.exs"
