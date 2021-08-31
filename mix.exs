defmodule Sunbake.MixProject do
  use Mix.Project

  def project do
    [
      app: :sunbake,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.7"},
      {:ex_doc, "~> 0.25.1"}
    ]
  end
end
