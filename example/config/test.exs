use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :js_routes_example, JsRoutesExampleWeb.Endpoint,
  http: [port: 4001],
  server: true,
  code_reloader: true,
  reloadable_compilers: [:gettext, :phoenix, :elixir, :jsroutes]

# Print only warnings and errors during test
config :logger, level: :warn

# config :hound, driver: "selenium"
# config :hound, browser: "chrome"

config :hound, driver: "phantomjs"
config :hound, http: [timeout: :infinity]
config :hound, http: [recv_timeout: :infinity]
