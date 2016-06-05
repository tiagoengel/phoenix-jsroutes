defmodule Mix.Tasks.Phoenix.Gen.Jsroutes do
  use Mix.Task
  require EEx

  @default_path "jsroutes.js"

  def run(args) do
    module = router(args)
    unless Code.ensure_loaded?(module) do
      raise_not_found module
    end

    routes = only_routes_with_helpers(module.__routes__)

    File.write!(@default_path, gen_routes(routes))
    Mix.Shell.IO.info "Generated #{@default_path}"
  end

  EEx.function_from_file :defp, :gen_routes, "priv/templates/jsroutes.exs", [:routes]

  defp router(args) do
   cond do
     # TODO: Suport umbrella applications
     Mix.Project.umbrella? ->
       Mix.raise "Umbrella applications are not supported"
     router = Enum.at(args, 0) ->
       Module.concat("Elixir", router)
     true ->
       Module.concat(Mix.Phoenix.base(), "Router")
   end
 end

 defp raise_not_found(module) do
   Mix.raise "module #{module} was not loaded and cannot be loaded"
 end

 # Phoenix creates two routes for updates, one with the "path" verb
 # and another with the "put" verb.
 # The one with the "put" verb comes without a helper and essentially they are
 # the same for us right now, so we will ignore the ones that don't have a helper
 defp only_routes_with_helpers(routes) do
   Enum.filter(routes, fn %{helper: helper} -> !is_nil(helper) end)
 end

end
