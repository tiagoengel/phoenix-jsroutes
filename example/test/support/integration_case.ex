defmodule JsRoutesExampleWeb.IntegrationCase do
  use ExUnit.CaseTemplate, async: false
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import JsRoutesExampleWeb.Router.Helpers
      import JsRoutesExampleWeb.IntegrationCase

      # The default endpoint for testing
      @endpoint JsRoutesExampleWeb.Endpoint

      hound_session()

      setup tags do
        maximize_window(current_window_handle())
        :ok
      end
    end
  end
end
