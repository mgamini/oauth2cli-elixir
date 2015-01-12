OAuth2Cli
======

Much (very much) of this code is derived from [Sonny Scroggin's great OAuth2 package](https://github.com/scrogson/oauth2), but it wasn't quite fitting my needs, so I ended up making my own. There are a few key differences between them.

OAuth2Cli:
> 1. Holds OAuth strategies in memory for later use
> 2. Doesn't normalize oauth responses, it simply returns them
> 3. Adds some features (using a discovery url, for example)
> 4. Is currently only able to use access codes for oauth, not user/pass

If you're looking for a simple oauth library that makes it really easy to send an access code (to Google in particular) and get a token back, this is the library you want.

# Usage
So far, I only have one situation coded out: utilizing an access code with [Google's OAuth2 API](https://developers.google.com/accounts/docs/OAuth2)

## Registration
Start by registering an oauth strategy:

### Simple example:
* This is the same as the multiple strategies example below, it simply sets its name to :default*
```elixir
params = %{
  client_id: "someid12345",
  client_secret: "somesecret12345",
  redirect_uri: "http://whatever.com/oauth",
  token_endpoint: "https://www.googleapis.com/oauth2/v3/token"
}
OAuth2Cli.register(params)
# > :ok
```

### Multiple strategies:
```elixir
params1 = %{
  client_id: "someid12345",
  client_secret: "somesecret12345",
  redirect_uri: "http://whatever.com/oauth",
  token_endpoint: "https://www.googleapis.com/oauth2/v3/token"
}
params2 = %{
  client_id: "someid12345",
  client_secret: "somesecret12345",
  redirect_uri: "http://whatever.com/oauth",
  token_endpoint: "https://someotherservice.com/oauth"
}
OAuth2Cli.register(:google, params1)
# > :ok
OAuth2Cli.register(:other, params2)
# > :ok
```

### Utilizing a discovery service:
```elixir
params = %{
  client_id: "someid12345",
  client_secret: "somesecret12345",
  redirect_uri: "http://whatever.com/oauth"
}
discovery_uri = "https://accounts.google.com/.well-known/openid-configuration"

OAuth2Cli.register(:google, params, discovery_uri)
# > :ok
```

## Authorizing Users
```elixir
OAuth2Cli.authorize_user("access_code_asdfasdfasdfasdfasdf")
# >  {:ok,
# >   %OAuth2Cli.Response{
# >    body: %{access_token: "asdfasdfasdfasdfsadfasdfasdf",
# >      expires_in: 3600,
# >      id_token: "asdfsadfsadfsadfsadfsadfsadfsadfsadfsadfasdfasdfa",
# >      token_type: "Bearer"},
# >    headers: [{"Cache-Control", "no-cache, no-store, max-age=0, must-revalidate"},
# >     {"Pragma", "no-cache"}, {"Expires", "Fri, 01 Jan 1990 00:00:00 GMT"},
# >     {"Date", "Mon, 05 Jan 2015 22:49:06 GMT"}, {"Vary", "Origin"},
# >     {"Vary", "X-Origin"}, {"Content-Type", "application/json; charset=UTF-8"},
# >     {"X-Content-Type-Options", "nosniff"}, {"X-Frame-Options", "SAMEORIGIN"},
# >     {"X-XSS-Protection", "1; mode=block"}, {"Server", "GSE"},
# >     {"Alternate-Protocol", "443:quic,p=0.02"}, {"Transfer-Encoding", "chunked"}],
# >    status_code: 200
# >    }
# >  }
```
or
```elixir
OAuth2Cli.authorize_user(:strategy_name, "codecodecode")
```
