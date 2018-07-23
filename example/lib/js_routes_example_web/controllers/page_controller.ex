defmodule JsRoutesExampleWeb.PageController do
  use JsRoutesExampleWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
