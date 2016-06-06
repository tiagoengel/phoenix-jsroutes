defmodule Mix.RouterTest do
  use Phoenix.Router
  get "/", PageController, :index, as: :page
  resources "/users", UserController
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

  test "allow to configure the output path" do
    Application.put_env(:phoenix_jsrouter, :jsrouter, output_path: "_build/test/tmp")
    Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
    Application.put_env(:phoenix_jsrouter, :jsrouter, nil)
    assert_file "_build/test/tmp/jsroutes.js"
    File.rm("_build/test/tmp/jsroutes.js")
  end


end
