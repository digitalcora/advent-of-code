defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: [],
      elixirc_paths: ["days", "lib"],
      test_paths: ["days", "lib"]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
