defmodule Sunbake.MixProject do
  use Mix.Project

  def project do
    [
      app: :sunbake,
      version: "0.2.4",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Sunbake",
      source_url: "https://github.com/bdanklin/sunbake"
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.25.1", only: :dev, runtime: false},
      {:ecto, "~> 3.7"},
      {:unsafe, "~> 1.0"}
    ]
  end

  defp description() do
    "Easy ecto integration of common types used within Discord."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bdanklin/sunbake"}
    ]
  end
end
