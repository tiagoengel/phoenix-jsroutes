{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, JsRoutesExampleWeb.Endpoint.url())
ExUnit.start()
