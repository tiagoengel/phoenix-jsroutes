defmodule JsRoutesExample.PageController do
  use JsRoutesExample.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
