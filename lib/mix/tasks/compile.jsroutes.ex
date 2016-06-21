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
    app               = Mix.Project.config[:app]
    app_env           = Application.get_env(app, :jsroutes) || Keyword.new
    output_folder     = Keyword.get(app_env, :output_folder, @default_out_folder)

    module = router(app, task_opts)
    file = Path.join(output_folder, @default_out_file)
    mappings = [{module, file}]

    Mix.Compilers.Phoenix.JsRoutes.compile(manifest, mappings, task_opts[:force], fn
      module, output ->
        routes = routes(module, app_env)
        File.mkdir_p(Path.dirname(output))
        File.write(output, gen_routes(routes))
    end)
  end

  @doc """
  Cleans up compilation artifacts.
  """
  def clean do
    Mix.Compilers.Phoenix.JsRoutes.clean(manifest())
  end

  defp manifest, do: Path.join(Mix.Project.manifest_path, @manifest)

  EEx.function_from_file :defp, :gen_routes, "priv/templates/jsroutes.exs", [:routes]

  defp router(app, args) do
   module = cond do
     # TODO: Suport umbrella applications
     Mix.Project.umbrella? ->
       Mix.raise "Umbrella applications are not supported"
     router = args[:router] ->
       Module.concat("Elixir", router)
     true ->
       Module.concat(base(app), "Router")
   end
   unless Code.ensure_loaded?(module) do
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

 defp match_filters?(%{path: path}, config) do
   include = Keyword.get(config, :include)
   exclude = Keyword.get(config, :exclude)

   match_include = !include || Regex.match?(include, path)
   match_exclude = !exclude || !Regex.match?(exclude, path)

   match_include && match_exclude
 end

 defp raise_module_not_found(module) do
   Mix.raise "module #{module} was not loaded and cannot be loaded"
 end

 defp raise_invalid_router(module) do
   Mix.raise "module #{module} is not a valid phoenix router"
 end
end
