defmodule Vr.Mixfile do
  use Mix.Project

  def project do
    [app: :vr,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Vr, []},
     applications: [:ex_machina, :phoenix, :phoenix_pubsub,:phoenix_html, 
                    :cowboy, :logger, :gettext,:comeonin,
                    :joken, :mellon, :scrivener_headers, :cors_plug,
                    :keccakf1600, :libdecaf, :libsodium, 
                    :ex_admin, :exactor, :hound,
                    :coherence,
                    :bamboo,
                    :bamboo_smtp,
                    :scrivener_ecto, :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.4"},
     {:exrm, "~> 1.0.8"},
     {:cors_plug, "~> 1.1"},
     {:ex_machina, "~> 1.0"},
     {:joken, "~> 1.1"},
     {:libsodium, "~> 0.0.3"},
     {:keccakf1600, "~> 2.0.0"},
     {:libdecaf, "~> 0.0.4"},
     {:bamboo, "~> 0.8"},
     {:bamboo_smtp, "~> 1.3.0"},
     {:scrivener_headers, "~> 3.0"},
     {:scrivener_ecto, "~> 1.1.3"},
     {:ex_admin, github: "smpallen99/ex_admin"},
     {:coherence, "~> 0.3"},
     {:ecto_enum, "~> 1.0"},
     {:mellon, "~> 0.1.1"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
