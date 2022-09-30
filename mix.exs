defmodule Content.MixProject do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
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
      {:exvcr, "~> 0.11", runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.8.0", override: true},
      {:ecto, "~> 3.8"}
    ]
  end

  defp docs do
    [
      formatters: ["html", "epub"],
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras do
    [
      "docs/introduction.md",
      "docs/quickstart/content_model.md",
      "docs/quickstart/api.md"
    ]
  end

  defp groups_for_extras do
    [
      Introduction: ~r/guides\/introduction\/.?/,
      Quickstart: ~r/docs\/quickstart\/[^\/]+\.md/
    ]
  end
end
