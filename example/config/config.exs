# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :js_routes_example,
  ecto_repos: []

# Configures the endpoint
config :js_routes_example, JsRoutesExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6p9ja70pTcGTWKlTdGSPMQehcSYiifzTsFsdGMtDKb5Dr7vHUJpfrHngtU/E05CW",
  render_errors: [view: JsRoutesExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JsRoutesExample.PubSub, adapter: Phoenix.PubSub.PG2]

config :js_routes_example, :jsroutes, output_folder: "priv/static/js"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# Watch static and templates for browser reloading.
config :js_routes_example, JsRoutesExampleWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/js_routes_example_web/router\.ex$},
      ~r{lib/js_routes_example_web/views/.*(ex)$},
      ~r{lib/js_routes_example_web/templates/.*(eex)$}
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
