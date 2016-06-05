defmodule PhoenixJsrouter do

  # {assigns: %{}, helper: "registration", host: nil,
  # kind: :match, opts: :create, path: "/api/registration", pipe_through: [:api],
  # plug: SystextilDDP.RegistrationController, private: %{}, verb: :post}

  def __routes__ do
    [
      %{helper: "user", opts: :create, path: "/users"},
      %{helper: "user", opts: :update, path: "/users/:id"},
      %{helper: "user_friends", opts: :create, path: "/users/:user_id/friends"},
      %{helper: "user_friends", opts: :update, path: "/users/:user_id/friends/:id"},
      %{helper: "user_friends", opts: :delete, path: "/users/:user_id/friends/:id"}
    ]
  end

  def function_name(%{helper: helper, opts: opts}) do
    "#{helper}_#{opts}" |> Mix.Utils.camelize |> downcase_first
  end

  defp downcase_first(<< first :: utf8, rest :: binary>>) do
    String.downcase(<<first>>) <> rest
  end

  def function_params(%{path: path}) do
    String.split(path, "/")
    |> Enum.filter(&(String.starts_with?(&1, ":")))
    |> Enum.join(", ")
    |> String.replace(":", "")
  end

  def function_body(%{path: path}) do
    Regex.split(~r{(?=/)}, path)
    |> Enum.map(fn
      <<"/:", rest :: binary>> -> "'/' + #{rest}"
      path_part -> "'#{path_part}'"
    end)
    |> Enum.join(" + ")
  end
end
