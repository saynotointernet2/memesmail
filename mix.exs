defmodule Memesmail.Mixfile do
  use Mix.Project

  def project do
    [
      app: :memesmail,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      mod: {Memesmail, []},
      extra_applications: [:logger]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.4.3"},
      {:cowboy, "~> 1.1.2"},
      {:poison, "~> 3.1.0"},
      {:postgrex, "~> 0.13.5"},
      {:ecto, "~> 2.2.6"},
      {:corsica, "~> 1.1.2"},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ed25519, "~> 1.3.0"},
      {:curve25519, "~> 1.0.2"}
    ]
  end
end


#defmodule KV.Mixfile do
#  use Mix.Project
#
#  def project do
#    [app: :kv,
#     version: "0.1.0",
#     elixir: "~> 1.3",
#     start_permanent: Mix.env == :prod,
#     deps: deps()]
#  end
#
#  def application do
#    [extra_applications: [:logger]]
#  end
#
#  defp deps do
#    []
#  end
#end
