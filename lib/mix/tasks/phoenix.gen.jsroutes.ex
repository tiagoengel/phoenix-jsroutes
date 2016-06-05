defmodule Mix.Tasks.Phoenix.Gen.Jsroutes do
  use Mix.Task

  require EEx
  EEx.function_from_file :def, :gen_routes, "priv/templates/jsroutes.exs", [:routes]

  def run(_) do
    File.write!("jsroutes.js", gen_routes(PhoenixJsrouter.__routes__))
    Mix.Shell.IO.info "Generated jsroutes.js"
  end
end
