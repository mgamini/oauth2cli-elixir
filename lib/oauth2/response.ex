defmodule OAuth2Cli.Response do
  alias OAuth2Cli.Error
  alias OAuth2Cli.Util

  @code_no_content [204, 304]
  @code_valid [200, 201, 202, 203, 205, 206]

  defstruct status_code: nil, body: nil, headers: %{}

  @type t :: %__MODULE__{status_code: integer, body: binary, headers: map}

  def new({:ok, body}, status_code, headers) do
    content_type = OAuth2Cli.Util.content_type(headers)

    body = decode_response_body(body, content_type) |> Util.atomize_keys

    if !status_code in @code_valid || Dict.has_key?(body, :error) do
      {:error, body}
    else
      {:ok, %__MODULE__{
        status_code: status_code,
        headers: headers,
        body: body
      }}
    end
  end

  defp decode_response_body(body, "application/json"), do:
    Poison.decode!(body)
  defp decode_response_body(body, "application/x-www-form-urlencoded"), do:
    Plug.Conn.Query.decode(body)
  defp decode_response_body(body, _), do: body
end
