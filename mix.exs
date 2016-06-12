defmodule PhoenixJsroutes.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_jsroutes,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:phoenix, ">= 1.0.0", only: :test},
     {:execjs, "~> 1.1.3", only: :test}]
  end

  defp description do
    """
    Brings phoenix router helpers to your javascript code.
    """
  end

  defp package do
    [name: :phoenix_jsroutes,
     files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
     licenses: ["MIT"],
     maintainers: ["Tiago Henrique Engel"],
     links: %{"GitHub" => "https://github.com/tiagoengel/phoenix-jsroutes"}]
  end

end
