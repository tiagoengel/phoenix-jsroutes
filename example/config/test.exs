use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :js_routes_example, JsRoutesExample.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :hound, driver: "selenium"
config :hound, browser: "chrome"

# Start Hound for ChromeDriver
# config :hound, driver: "chrome_driver"
config :hound, http: [timeout: :infinity]
config :hound, http: [recv_timeout: :infinity]
