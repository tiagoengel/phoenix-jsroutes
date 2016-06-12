defmodule Mix.RouterTest do
  use Phoenix.Router
  get "/", PageController, :index, as: :page
  resources "/users", UserController
  scope "/api" do
    get "/products", ProductController, :index
    put "/orders/:id", OrderController, :update
    resources "/admin", AdminController
  end
end

defmodule Mix.Tasks.Compile.JsroutesTest do
  use ExUnit.Case

  import TestHelper

  setup do
    File.rm_rf("web/")
    :ok
  end

  test "generates a valid javascript module" do
    run_with_env([output_folder: "/tmp"], fn ->
      Mix.Tasks.Compile.Jsroutes.run(["Mix.RouterTest"])
      assert_file "/tmp/phoenix-jsroutes.js"

      jsroutes = Execjs.compile("var routes = require('./phoenix-jsroutes')")
      assert call_js(jsroutes, "routes.userIndex", []) == "/users"
      assert call_js(jsroutes, "routes.userCreate", []) == "/users"
      assert call_js(jsroutes, "routes.userUpdate", [1]) == "/users/1"
      assert call_js(jsroutes, "routes.userDelete", [1]) == "/users/1"
      assert call_js(jsroutes, "routes.userEdit", [1]) == "/users/1/edit"

      assert call_js(jsroutes, "routes.productIndex", []) == "/api/products"
      assert call_js(jsroutes, "routes.orderUpdate", [1]) == "/api/orders/1"

      File.rm("/tmp/phoenix-jsroutes.js")
    end)
  end

  test "ignore the first argument when it is not a valid module name" do
    Mix.Tasks.Compile.Jsroutes.run(["--no-halt"])
    Mix.Tasks.Compile.Jsroutes.run(["-arg"])
    Mix.Tasks.Compile.Jsroutes.run([])
    assert_raise(Mix.Error, "module Elixir.NotFound was not loaded and cannot be loaded", fn ->
      Mix.Tasks.Compile.Jsroutes.run(["NotFound"])
    end)
  end

  test "allows to configure the output path" do
    run_with_env([output_folder: "_build/test/tmp"], fn ->
      Mix.Tasks.Compile.Jsroutes.run(["Mix.RouterTest"])
      assert_file "_build/test/tmp/phoenix-jsroutes.js"
      File.rm("_build/test/tmp/phoenix-jsroutes.js")
    end)
  end

  test "allows to filter urls" do
    run_with_env([include: ~r[api/], exclude: ~r[/admin]], fn ->
      Mix.Tasks.Compile.Jsroutes.run(["Mix.RouterTest"])
      assert_contents "web/static/js/phoenix-jsroutes.js", fn file ->
        refute file =~ "page"
        refute file =~ "user"
        refute file =~ "admin"

        assert file =~ "productIndex() {"
        assert file =~ "return '/api/products';"

        assert file =~ "orderUpdate(id) {"
        assert file =~ "return '/api/orders/' + id;"
      end
    end)
  end

  test "clean up compilation artifacts" do
    Mix.Tasks.Compile.Jsroutes.run([])
    assert_file "web/static/js/phoenix-jsroutes.js"
    Mix.Tasks.Compile.Jsroutes.clean()
    refute_file "web/static/js/phoenix-jsroutes.js"
  end

  defp run_with_env(env, fun) do
    try do
      Application.put_env(:phoenix_jsroutes, :jsroutes, env)
      fun.()
    after
      Application.put_env(:phoenix_jsroutes, :jsroutes, nil)
    end
  end

  defp call_js(context, fun, args) do
    Execjs.call(context, fun, args)
  end
end
