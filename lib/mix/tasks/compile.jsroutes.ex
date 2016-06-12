defmodule Mix.Tasks.Compile.Jsroutes do
  use Mix.Task
  require EEx

  @shortdoc "Generates helpers to access server paths via javascript"
  @manifest ".compile.jsroutes"

  @default_out_folder "web/static/js"
  @default_out_file "phoenix-jsroutes.js"

  @spec run(OptionParser.argv) :: :ok | :noop
  def run(args) do
    {task_opts, _, _} = OptionParser.parse(args, switches: [force: :boolean])

    app = Mix.Project.config[:app]
    app_env = Application.get_env(app, :jsroutes) || Keyword.new

    module = router(app, args)
    output_folder = Keyword.get(app_env, :output_folder, @default_out_folder)
    file = Path.join(output_folder, @default_out_file)
    mappings = [{module, file}]

    manifest = Path.join(Mix.Project.manifest_path, @manifest)

    Mix.Compilers.Phoenix.JsRoutes.compile(manifest, mappings, task_opts[:force], fn
      module, output ->
        routes = routes(module, app_env)
        File.mkdir_p(Path.dirname(output))
        File.write(output, gen_routes(routes))
    end)
  end

  EEx.function_from_file :defp, :gen_routes, "priv/templates/jsroutes.exs", [:routes]

  defp router(app, args) do
   module = cond do
     # TODO: Suport umbrella applications
     Mix.Project.umbrella? ->
       Mix.raise "Umbrella applications are not supported"
     router = parse_args(args) ->
       Module.concat("Elixir", router)
     true ->
       Module.concat(base(app), "Router")
   end
   unless Code.ensure_compiled?(module) do
     raise_module_not_found module
   end
   module
 end

 defp base(app) do
  case Application.get_env(app, :namespace, app) do
    ^app -> app |> to_string |> Macro.camelize
    mod  -> mod |> inspect
  end
end

 # TODO: add a better validation
 defp parse_args(args) do
   module = Enum.at(args, 0)
   if String.starts_with?(module || "-", "-"), do: nil, else: module
 end

 defp routes(router, config) do
   unless router.__routes__ do
     raise_invalid_router router
   end

   Enum.filter(router.__routes__, fn route ->
     route_has_helper?(route) && match_filters?(route, config)
   end)
 end

 # Phoenix creates two routes for updates, one with the "path" verb
 # and another with the "put" verb.
 # The one with the "put" verb comes without a helper and essentially they are
 # the same for us right now, so we will ignore the ones that don't have a helper
 defp route_has_helper?(%{helper: helper}), do: !is_nil(helper)

 defp match_filters?(%{path: path}, [include: include]),
  do: Regex.match?(include, path)
 defp match_filters?(%{path: path}, [exclude: exclude]),
  do: !Regex.match?(exclude, path)
 defp match_filters?(%{path: path}, [include: include, exclude: exclude]),
  do: Regex.match?(include, path) && !Regex.match?(exclude, path)
 defp match_filters?(_route, _), do: true

 defp raise_module_not_found(module) do
   Mix.raise "module #{module} was not loaded and cannot be loaded"
 end

 defp raise_invalid_router(module) do
   Mix.raise "module #{module} is not a valid phoenix router"
 end
end
