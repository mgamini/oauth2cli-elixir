defmodule OAuth2Cli do
  @moduledoc """
  OAuth2Cli
  """
  use Application

  alias OAuth2Cli.Authorize
  alias OAuth2Cli.Manager

  def start(_type, _args) do
    OAuth2Cli.Supervisor.start_link
  end

  def register(params), do: Manager.register(params)
  def register(name, params) when is_atom(name), do: Manager.register({name, params})
  def register(name, params, discovery) when is_atom(name), do: Manager.register({name, params, discovery})

  def authorize_user(code, strategy \\ :default, params \\ %{}) when is_atom(strategy) and is_binary(code), do:
    Authorize.authorize_user(code, strategy, params)

end

