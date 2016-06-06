defmodule Mix.RouterTest do
  use Phoenix.Router
  get "/", PageController, :index, as: :page
  resources "/users", UserController
  scope "/api" do
    get "/products", ProductController, :index
    put "/orders/:id", OrderController, :update
  end
end

defmodule Mix.Tasks.Phoenix.Gen.JsroutesTest do
  use ExUnit.Case

  import TestHelper

  setup do
    File.rm_rf("web/")
    :ok
  end

  test "generates a valid javascript module" do
    run_with_env([output_folder: "/tmp"], fn ->
      Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
      assert_file "/tmp/jsroutes.js"

      jsroutes = Execjs.compile("var routes = require('./jsroutes')")
      assert call_js(jsroutes, "routes.userIndex", []) == "/users"
      assert call_js(jsroutes, "routes.userCreate", []) == "/users"
      assert call_js(jsroutes, "routes.userUpdate", [1]) == "/users/1"
      assert call_js(jsroutes, "routes.userDelete", [1]) == "/users/1"
      assert call_js(jsroutes, "routes.userEdit", [1]) == "/users/1/edit"

      assert call_js(jsroutes, "routes.productIndex", []) == "/api/products"
      assert call_js(jsroutes, "routes.orderUpdate", [1]) == "/api/orders/1"

      File.rm("/tmp/jsroutes.js")
    end)
  end

  test "allows to configure the output path" do
    run_with_env([output_folder: "_build/test/tmp"], fn ->
      Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
      assert_file "_build/test/tmp/jsroutes.js"
      File.rm("_build/test/tmp/jsroutes.js")
    end)
  end

  test "allows to filter urls" do
    run_with_env([url_filter: ~r[api/]], fn ->
      Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
      assert_contents "web/static/js/jsroutes.js", fn file ->
        refute file =~ "page"
        refute file =~ "user"

        assert file =~ "productIndex() {"
        assert file =~ "return '/api/products';"

        assert file =~ "orderUpdate(id) {"
        assert file =~ "return '/api/orders/' + id;"
      end
    end)
  end

  defp run_with_env(env, fun) do
    try do
      Application.put_env(:phoenix_jsrouter, :jsrouter, env)
      fun.()
    after
      Application.put_env(:phoenix_jsrouter, :jsrouter, nil)
    end
  end

  defp call_js(context, fun, args) do
    Execjs.call(context, fun, args)
  end
end
