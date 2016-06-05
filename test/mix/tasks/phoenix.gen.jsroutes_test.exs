defmodule Mix.RouterTest do
  use Phoenix.Router
  get "/", PageController, :index, as: :page
  resources "/users", UserController
end

defmodule Mix.Tasks.Phoenix.Gen.JsroutesTest do
  use ExUnit.Case

  import TestHelper

  setup do
    File.rm("jsroutes.js")
    :ok
  end

  test "gen_routes generates a valid javascript module" do

  end

  test "generate javascript routes for a specific phoenix router" do
    Mix.Tasks.Phoenix.Gen.Jsroutes.run(["Mix.RouterTest"])
    assert_file "jsroutes.js", fn file ->
      assert file =~ "pageIndex() {"
      assert file =~ "return '/';"

      assert file =~ "userUpdate(id) {"
      assert file =~ "return '/users/' + id;"
    end
  end


end
