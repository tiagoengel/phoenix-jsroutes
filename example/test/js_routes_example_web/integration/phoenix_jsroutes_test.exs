defmodule JsRoutesExampleWeb.PhoenixJsRoutesTest do
  use JsRoutesExampleWeb.IntegrationCase

  test "have access to router functions", %{session: session} do
    routes =
      session
      |> visit("/")
      |> get_visible_routes()

    assert length(routes) == 3
    assert routes == default_routes()
  end

  test "recompiles the js router when the router changes", %{session: session} do
    routes =
      session
      |> visit("/")
      |> get_visible_routes()

    assert length(routes) == 3

    new_routes = "
    get \"/user/:id\", TestUserController, :index
    post \"/user/:userId/projects/:id\", TestUserProjectsController, :update
    "

    with_new_routes(new_routes, fn ->
      expected_routes =
        default_routes() ++
          [
            {"testUserIndex", "/test/user/0"},
            {"testUserProjectsUpdate", "/test/user/0/projects/1"}
          ]

      routes =
        session
        |> visit("/")
        |> get_visible_routes()

      assert length(routes) == 5
      assert routes == expected_routes
    end)
  end

  defp get_visible_routes(page) do
    page
    |> find(css("#routes-container"))
    |> all(css("li"))
    |> Enum.map(fn li ->
      li
      |> all(css("span"))
      |> Enum.map(&Wallaby.Element.text/1)
      |> List.to_tuple()
    end)
  end

  defp default_routes do
    [{"pageIndex", "/"}, {"apiPage", "/api/page/0/1"}, {"apiTest", "/api/test/0/fixed/1"}]
  end

  defp with_new_routes(new_routes, func) do
    router_path = Path.expand("../../../lib/js_routes_example_web/router.ex", __DIR__)
    original_route = File.read!(router_path)
    jsrouter_path = Path.expand("../../../priv/static/js/phoenix-jsroutes.js", __DIR__)
    original_jsroute = File.read!(jsrouter_path)

    try do
      new_file = String.replace(original_route, ~r/# TEST-PLACEHOLDER #/, new_routes)
      File.write!(router_path, new_file)
      func.()
    after
      File.write!(router_path, original_route)
      File.write!(jsrouter_path, original_jsroute)
    end
  end
end
