defmodule JsRoutesExample.Router do
  use JsRoutesExample.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JsRoutesExample do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", JsRoutesExample do
    pipe_through :api # Use the default browser stack

    post "/page/:id/:name", ApiController, :page
    put "test/:name/fixed/:arg", ApiController, :test
  end

  scope "/test", JsRoutesExample do
    #TEST-PLACEHOLDER#
  end

  # Other scopes may use custom stacks.
  # scope "/api", JsRoutesExample do
  #   pipe_through :api
  # end
end
