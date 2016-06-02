defmodule PhoenixJsrouter do

  def __routes__ do
    [
      %{name: "user_path", path: "/users/:id"},
      %{name: "products_path", path: "/products/:id"},
      %{name: "product_components_path", path: "/products/:id/components"}
    ]
  end



end
