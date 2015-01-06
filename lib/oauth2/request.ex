defmodule OAuth2Cli.Request do
  use HTTPoison.Base

  alias OAuth2Cli.Error
  alias OAuth2Cli.Response

  def request(method, url, body \\ "", headers \\ [], opts \\ []) do
    content_type = OAuth2Cli.Util.content_type(headers)
    url = process_url(to_string(url))
    body = process_request_body(body, content_type)
    headers = process_request_headers(headers, content_type)

    :hackney.request(method, url, headers, body, opts) |> do_request
  end

  def request!(method, url, body \\ "", headers \\ [], options \\ []) do
    case request(method, url, body, headers, options) do
      {:ok, response} -> response
      {:error, error} -> raise error
    end
  end

  defp process_request_headers(headers, content_type), do:
    [{"Accept", content_type} | headers]

  defp process_request_body("", _), do: ""
  defp process_request_body(body, "application/json"), do:
    Poison.encode!(body)
  defp process_request_body(body, "application/x-www-form-urlencoded"), do:
    Plug.Conn.Query.encode(body)

  defp do_request({:ok, status_code, headers, client}), do:
    Response.new(:hackney.body(client), status_code, headers)
  defp do_request({:error, reason}), do:
    {:error, %Error{reason: reason}}
end