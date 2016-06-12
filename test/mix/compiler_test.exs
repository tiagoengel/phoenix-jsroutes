defmodule Mix.Compilers.Phoenix.JsRoutes.RouterTest  do
  use Phoenix.Router
  get "/", PageController, :index, as: :page
  resources "/users", UserController
  scope "/api" do
    get "/products", ProductController, :index
    put "/orders/:id", OrderController, :update
  end
end

defmodule Mix.Compilers.Phoenix.JsRoutesTest do
  use ExUnit.Case

  alias Mix.Compilers.Phoenix.JsRoutes.RouterTest

  @manifest "_build/test/lib/phoenix_jsroutes/compile.jsroutes"

  setup do
    on_exit fn ->
      File.rm(@manifest)
    end
  end

  test "fires the callback and writes the manifest" do
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    assert File.exists?(@manifest)
  end

  test "return :noop when there's no change" do
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    assert :noop = compile({RouterTest, "web/static/teste-routes.js"})
  end

  test "fires again when the module code changes" do
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    redefine_module!
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
  end

  test "fires the callback for every module in the mappings" do
    mappings = [
      {RouterTest, "web/static/teste-routes.js"},
      {Elixir.Atom, "web/static/atom.js"},
      {Elixir.Agent, "web/static/agent.js"}
    ]
    {:ok, agent} = Agent.start_link(fn -> 0 end)
    assert :ok = Mix.Compilers.Phoenix.JsRoutes.compile(@manifest, mappings, false, fn (module, output) ->
      idx = Agent.get_and_update(agent, fn call -> {call, call + 1} end)
      {expected_module, expected_out} = Enum.fetch!(mappings, idx)
      assert expected_module == module
      assert expected_out == output
      :ok
    end)
    assert Agent.get(agent, fn call -> call end) == 3
    Agent.stop(agent)
  end

  test "keeps the manifest up to date" do
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    redefine_module!
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    entries = Mix.Compilers.Phoenix.JsRoutes.read_manifest(@manifest)
    assert length(entries) == 1
    new_hash = RouterTest.module_info[:md5]
    assert {RouterTest, ^new_hash, "web/static/teste-routes.js"} = Enum.fetch!(entries, 0)
  end

  test "remove outputs that are not in the mappings anymore" do
    File.mkdir_p!("web/static/")
    File.write!("web/static/teste-routes.js", "")
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    assert :ok = compile({RouterTest, "web/static/teste-routes-new.js"})
    refute File.exists?("web/static/teste-routes.js")
    entries = Mix.Compilers.Phoenix.JsRoutes.read_manifest(@manifest)
    assert length(entries) == 1
    assert {RouterTest, _, "web/static/teste-routes-new.js"} = Enum.fetch!(entries, 0)
  end

  test "remove modules that are not in the mappings anymore" do
    File.mkdir_p!("web/static/")
    File.write!("web/static/teste-routes.js", "")
    assert :ok = compile({RouterTest, "web/static/teste-routes.js"})
    assert :ok = compile({Elixir.Agent, "web/static/agent.js"})
    refute File.exists?("web/static/teste-routes.js")
    entries = Mix.Compilers.Phoenix.JsRoutes.read_manifest(@manifest)
    assert length(entries) == 1
    assert {Elixir.Agent, _, "web/static/agent.js"} = Enum.fetch!(entries, 0)
  end

  defp compile({expected_module, expected_out}) do
    mappings = [{expected_module, expected_out}]
    Mix.Compilers.Phoenix.JsRoutes.compile(@manifest, mappings, false, fn (module, output) ->
      assert expected_module == module
      assert expected_out == output
      :ok
    end)
  end

  defp redefine_module! do
    Code.compile_quoted(quote do
      defmodule Mix.Compilers.Phoenix.JsRoutes.RouterTest do
        # Always define a new function name to force the module's hash to change
        def unquote(:"a_#{system_time}")(), do: "test"
      end
    end)
  end

  defp system_time do
    {mega, seconds, ms} = :os.timestamp()
    (mega*1000000 + seconds)*1000 + :erlang.round(ms/1000)
  end
end
