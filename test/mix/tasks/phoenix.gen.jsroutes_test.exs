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

  test "gen_routes generates a valid javascript module" do

  end

  test "generate javascript routes for a specific phoenix router" do
    Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
    assert_contents "web/static/js/jsroutes.js", fn file ->
      assert file =~ "pageIndex() {"
      assert file =~ "return '/';"

      assert file =~ "userUpdate(id) {"
      assert file =~ "return '/users/' + id;"
    end
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


end
