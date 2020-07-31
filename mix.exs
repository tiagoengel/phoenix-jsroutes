defmodule PhoenixJsroutes.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_jsroutes,
      version: "2.0.0",
      elixir: "~> 1.4",
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
    [
      {:phoenix, ">= 1.4.0", only: :test},
      {:execjs, "~> 1.2",
       github: "devinus/execjs", sha: "a1c0af4c3b0afc9d6f176bf82f9c5b9fae3f2a45", only: :test},
      {:poison, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
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
