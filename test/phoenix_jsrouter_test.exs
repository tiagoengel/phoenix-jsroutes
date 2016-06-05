defmodule PhoenixJsrouterTest do
  use ExUnit.Case
  doctest PhoenixJsrouter

  import PhoenixJsrouter

  def __routes__ do
    [
      %{helper: "user", opts: :create, path: "/users"},
      %{helper: "user", opts: :update, path: "/users/:id"},
      %{helper: "user_friends", opts: :create, path: "/users/:user_id/friends"},
      %{helper: "user_friends", opts: :update, path: "/users/:user_id/friends/:id"},
      %{helper: "user_friends", opts: :delete, path: "/users/:user_id/friends/:id"}
    ]
  end

  test "function_name returns the camelized js function name" do
    assert function_name(%{helper: "user", opts: :create}) == "userCreate"
    assert function_name(%{helper: "user_friends", opts: :update}) == "userFriendsUpdate"
    assert function_name(%{helper: "User_friends", opts: :delete}) == "userFriendsDelete"
  end

  test "function_params returns the list of params" do
    assert function_params(%{path: "/users"}) == ""
    assert function_params(%{path: "/users/:id"}) == "id"
    assert function_params(%{path: "/users/:user_id/friends/:id"}) == "user_id, id"
    assert function_params(%{path: "/users/:user_id/:id"}) == "user_id, id"
  end

  test "function_body returns a valid javascript expression with an url" do
    assert function_body(%{path: "/users"}) == "'/users'"
    assert function_body(%{path: "/users/:id"}) == "'/users' + '/' + id"
    assert function_body(%{path: "/users/:user_id/friends"}) == "'/users' + '/' + user_id + '/friends'"
    assert function_body(%{path: "/users/:user_id/friends/:id"}) == "'/users' + '/' + user_id + '/friends' + '/' + id"
  end
end
