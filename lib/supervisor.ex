defmodule OAuth2Cli.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      worker(OAuth2Cli.Manager, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

end