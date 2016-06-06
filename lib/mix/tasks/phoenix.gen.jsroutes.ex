defmodule Mix.Tasks.Phoenix.Gen.Jsroutes do
  use Mix.Task
  require EEx

  @default_path "web/static/js"

  def run(args) do
    module = router(args)
    unless Code.ensure_loaded?(module) do
      raise_not_found module
    end

    routes = only_routes_with_helpers(module.__routes__)
    otp_app = Mix.Phoenix.otp_app()
    config = Application.get_env(otp_app, :jsrouter) || Keyword.new
    path = Keyword.get(config, :output_path, @default_path)

    file = "#{path}/jsroutes.js"

    File.mkdir_p!(path)

    File.write!(file, gen_routes(routes))
    Mix.Shell.IO.info("Generated #{file}")
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
