defmodule JsRoutesExampleWeb.Router do
  use JsRoutesExampleWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", JsRoutesExampleWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", JsRoutesExampleWeb do
    # Use the default browser stack
    pipe_through(:api)

    post("/page/:id/:name", ApiController, :page)
    put("/test/:name/fixed/:arg", ApiController, :test)
  end

  scope "/test", JsRoutesExampleWeb do
    # TEST-PLACEHOLDER#
  end

  # Other scopes may use custom stacks.
  # scope "/api", JsRoutesExampleWeb do
  #   pipe_through :api
  # end
end
