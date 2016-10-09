defmodule JsRoutesExample.PhoenixJsRoutesTest do
  use JsRoutesExample.IntegrationCase

  test "jsroutes" do
    navigate_to "/"
    routes = find_element(:css, "#routes-container")
      |> find_all_within_element(:tag, "li")

    assert length(routes) == 3
  end
end
