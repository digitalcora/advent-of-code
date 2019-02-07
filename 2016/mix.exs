defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: [],
      elixirc_paths: ["days"],
      test_paths: ["days"]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
