defmodule Mix.Tasks.Phoenix.Gen.Jsroutes do
  use Mix.Task
  require EEx

  def run(args) do
    %{output_folder: folder, url_filter: url_filter} = config

    module = router(args)
    routes = routes(module, url_filter)

    File.mkdir_p!(folder)
    file = "#{folder}/jsroutes.js"

    File.write!(file, gen_routes(routes))
    Mix.Shell.IO.info("Generated #{file}")
  end

  EEx.function_from_file :defp, :gen_routes, "priv/templates/jsroutes.exs", [:routes]

  defp router(args) do
   module = cond do
     # TODO: Suport umbrella applications
     Mix.Project.umbrella? ->
       Mix.raise "Umbrella applications are not supported"
     router = parse_args(args) ->
       Module.concat("Elixir", router)
     true ->
       Module.concat(Mix.Phoenix.base(), "Router")
   end
   unless Code.ensure_loaded?(module) do
     raise_module_not_found module
   end
   module
 end

 # TODO: add a better validation
 defp parse_args(args) do
   module = Enum.at(args, 0)
   if String.starts_with?(module || "-", "-"), do: nil, else: module
 end

 defp routes(router, filter) do
   unless router.__routes__ do
     raise_invalid_router router
   end
   Enum.filter(router.__routes__, fn route ->
     route_has_helper?(route) && match_filter?(route, filter)
   end)
 end

 # Phoenix creates two routes for updates, one with the "path" verb
 # and another with the "put" verb.
 # The one with the "put" verb comes without a helper and essentially they are
 # the same for us right now, so we will ignore the ones that don't have a helper
 defp route_has_helper?(%{helper: helper}), do: !is_nil(helper)

 defp match_filter?(_route, nil), do: true
 defp match_filter?(%{path: path}, regex), do: Regex.match?(regex, path)

 @output_folder "web/static/js"

 defp config do
   otp_app = Mix.Project.config[:app]
   config = Application.get_env(otp_app, :jsrouter) || Keyword.new
   %{
     output_folder: Keyword.get(config, :output_folder, @output_folder),
     url_filter: Keyword.get(config, :url_filter)
   }
 end

 defp raise_module_not_found(module) do
   Mix.raise "module #{module} was not loaded and cannot be loaded"
 end

 defp raise_invalid_router(module) do
   Mix.raise "module #{module} is not a valid phoenix router"
 end

end
