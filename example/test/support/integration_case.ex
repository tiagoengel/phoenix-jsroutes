defmodule JsRoutesExampleWeb.IntegrationCase do
  use ExUnit.CaseTemplate, async: false

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query
      import Wallaby.Browser
    end
  end

  setup do
    {:ok, session} = Wallaby.start_session()
    {:ok, session: session}
  end
end
