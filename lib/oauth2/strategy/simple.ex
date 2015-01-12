defmodule OAuth2Cli.Strategy.Simple do
  alias OAuth2Cli.Request
  alias OAuth2Cli.Error

  defstruct client_id: nil,
    client_secret: nil,
    site: "",
    authorization_endpoint: "/oauth/authorize",
    token_endpoint: "",
    grant_type: "authorization_code",
    token_method: :post,
    params: %{},
    headers: %{},
    redirect_uri: "",
    token_request_keys: [:client_id, :client_secret, :redirect_uri, :grant_type]

  def new(params) do
    {:ok, struct(__MODULE__, sanitize_params(params))}
  end

  def authorize_user(code, strategy, params) do
    request = Dict.take(strategy |> Map.from_struct, strategy.token_request_keys)
      |> Dict.put(:code, code)
      |> Dict.merge(params |> sanitize_params())

    case Request.post(token_url(strategy), request, headers(strategy), []) do
      {:error, reason} -> {:error, %Error{reason: reason}}
      response -> response
    end
  end

  defp headers(strategy), do:
    [{"Content-Type", "application/x-www-form-urlencoded"} | Dict.to_list(strategy.headers)]

  defp token_url(strategy) do
    base = strategy.token_endpoint

    if strategy.token_endpoint |> String.first == "/", do:
      base = strategy.site <> strategy.token_endpoint

    base <> "?"
  end

  defp sanitize_params(params) do
    Enum.reduce(params, %{}, fn({k, v}, acc) ->
      if (is_list(v)), do:
        v = List.to_string(v)

      Dict.put(acc, k, v)
    end)
  end

end

