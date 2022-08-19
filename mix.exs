defmodule Content.MixProject do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.8.0", override: true},
      {:ecto, "~> 3.8"}
    ]
  end
end
