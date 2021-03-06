defmodule OAuth2Cli.Mixfile do
  use Mix.Project

  @description """
  Simple OAuth2 client
  """

  def project do
    [
      app: :oauth2cli,
      version: "0.0.4",
      elixir: "~> 1.0",
      deps: deps,
      description: @description,
      package: [
        contributors: ["Garrett Amini", "Sonny Scroggin", "Nate West", "Jamie Winsor"],
        licenses: ["MIT"],
        links: %{"Github": "https://github.com/mgamini/oauth2cli-elixir"}
      ]
    ]
  end

  def application do
    [
      mod: { OAuth2Cli, [] },
      applications: [:httpoison],
      registered: [
        OAuth2Cli.Manager
      ]
    ]
  end

  defp deps do
    [
      {:hackney,      "~> 1.0"},
      {:httpoison,    "~> 0.6.0"},
      {:poison,       "~> 1.3"},
      {:cowboy,       "~> 1.0.0", optional: true},
      {:plug,         "~> 0.9.0"},
    ]
  end
end
