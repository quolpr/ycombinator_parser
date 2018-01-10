defmodule Ycombinator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ycombinator,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Ycombinator, []},
      extra_applications: [:logger, :httpotion, :poison, :html_sanitize_ex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:poison, "~> 3.1"},
      {:httpotion, "~> 3.0.2"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
