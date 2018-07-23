defmodule JsRoutesExampleWeb.PhoenixJsRoutesTest do
  use JsRoutesExampleWeb.IntegrationCase

  test "have access to router functions" do
    navigate_to("/")
    routes = get_visible_routes()
    assert length(routes) == 3
    assert routes == default_routes()
  end

  test "recompiles the js router when the router changes" do
    navigate_to("/")
    new_routes = "
    get \"user/:id\", TestUserController, :index
    post \"user/:userId/projects/:id\", TestUserProjectsController, :update
    "

    with_new_routes(new_routes, fn ->
      refresh_page()

      expected_routes =
        default_routes() ++
          [
            {"testUserIndex", "/test/user/0"},
            {"testUserProjectsUpdate", "/test/user/0/projects/1"}
          ]

      routes = get_visible_routes()
      assert length(routes) == 5
      assert routes == expected_routes
    end)
  end

  defp get_visible_routes do
    find_element(:css, "#routes-container")
    |> find_all_within_element(:tag, "li")
    |> Enum.map(fn li ->
      find_all_within_element(li, :tag, "span")
      |> Enum.map(&visible_text/1)
      |> List.to_tuple()
    end)
  end

  defp default_routes do
    [{"pageIndex", "/"}, {"apiPage", "/api/page/0/1"}, {"apiTest", "/api/test/0/fixed/1"}]
  end

  defp with_new_routes(new_routes, func) do
    router_path = Path.expand("../../web/router.ex", __DIR__)
    original_route = File.read!(router_path)
    jsrouter_path = Path.expand("../../priv/static/js/phoenix-jsroutes.js", __DIR__)
    original_jsroute = File.read!(jsrouter_path)

    try do
      new_file = String.replace(original_route, ~r/#TEST-PLACEHOLDER#/, new_routes)
      File.write!(router_path, new_file)
      func.()
    after
      File.write!(router_path, original_route)
      File.write!(jsrouter_path, original_jsroute)
    end
  end
end
