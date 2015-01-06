defmodule OAuth2Cli.Error do
  defexception [:reason]
  def message(%__MODULE__{reason: reason}), do: inspect reason
end

