defmodule PhoenixJsroutes.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_jsroutes,
      version: "0.0.4",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:phoenix, ">= 1.0.0", only: :test}, {:execjs, "~> 1.1.3", only: :test}]
  end

  defp description do
    """
    Brings phoenix router helpers to your javascript code.
    """
  end

  defp package do
    [
      name: :phoenix_jsroutes,
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Tiago Henrique Engel"],
      links: %{"GitHub" => "https://github.com/tiagoengel/phoenix-jsroutes"}
    ]
  end
end
