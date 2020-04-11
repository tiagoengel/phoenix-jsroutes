defmodule PhoenixJsroutes do
  def function_name(%{helper: helper, opts: opts}) do
    "#{helper}_#{opts}" |> Macro.camelize() |> downcase_first
  end

  defp downcase_first(<<first::utf8, rest::binary>>) do
    String.downcase(<<first>>) <> rest
  end

  def function_params(%{path: path}) do
    String.split(path, "/")
    |> Enum.filter(&String.starts_with?(&1, ":"))
    |> Enum.join(", ")
    |> String.replace(":", "")
  end

  def function_body(%{path: path}) do
    PhoenixJsroutes.UrlTransformer.to_js(path)
  end

  # just for tests, so we can run the task in this project.
  # Should go away in the future
  defmodule Router do
    def __routes__ do
      [
        %{helper: "user", opts: :create, path: "/users"},
        %{helper: "user", opts: :update, path: "/users/:id"},
        %{helper: "user_friends", opts: :create, path: "/users/:user_id/friends"},
        %{helper: "user_friends", opts: :update, path: "/users/:user_id/friends/:id"},
        %{helper: "user_friends", opts: :delete, path: "/users/:user_id/friends/:id"}
      ]
    end
  end
end
