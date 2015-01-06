defmodule OAuth2Cli.Util do

  def unix_now do
    {mega, sec, _micro} = :erlang.now
    (mega * 1_000_000) + sec
  end

  def content_type(headers) do
    case List.keyfind(headers, "Content-Type", 0) do
      {"Content-Type", content_type} ->
        case Plug.Conn.Utils.content_type(content_type) do
          {:ok, type, subtype, _headers} ->
            type <> "/" <> subtype
          :error ->
            "application/json"
        end
      nil ->
        "application/json"
    end
  end

  def atomize_keys(map) when is_map(map) do
    Enum.into map, %{}, fn
      {key, value} when is_binary(key) and is_map(value) ->
        {String.to_atom(key), atomize_keys(value)}
      {key, value} when is_binary(key) ->
        {String.to_atom(key), value}
      {key, value} when is_map(value) ->
        {key, atomize_keys(value)}
      pair ->
        pair
    end
  end
end
