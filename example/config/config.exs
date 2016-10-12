# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the namespace used by Phoenix generators
config :js_routes_example,
  app_namespace: JsRoutesExample

# Configures the endpoint
config :js_routes_example, JsRoutesExample.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "IZaRS+IBmmIHldm575A6Qu+oHhZo6Hm4fj4SK2Mrysd2M6C5Q1Kd116SGs3BjM7P",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: JsRoutesExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :js_routes_example, :jsroutes,
  output_folder: "priv/static/js"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
