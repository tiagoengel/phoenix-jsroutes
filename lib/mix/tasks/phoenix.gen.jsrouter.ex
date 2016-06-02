defmodule PhoenixJsrouterGenerator do
  require EEx
  EEx.function_from_file :def, :gen_routes, "./lib/templates/jsroutes.exs", [:routes]
end

defmodule PhoenixJsrouterLoader do
  defmacro __using__(opts) do
    quote do
      def jsrouter do
        unquote(PhoenixJsrouterGenerator.gen_routes(Module.concat(Elixir, "PhoenixJsrouter").__routes__))
      end
    end
  end
end

defmodule Mix.Task.PhoenixJsrouter do
  # use PhoenixJsrouterLoader
  # router = Module.concat(Elixir, "PhoenixJsrouter")
  #
  quote do
    jsrouter = unquote(PhoenixJsrouterGenerator.gen_routes(Module.concat(Elixir, "PhoenixJsrouter").__routes__))
    IO.puts jsrouter 
  end


  # :ok = File.write("jsroutes.js", jsroutes)

end
