defmodule JsRoutesExample.IntegrationCase do
  use ExUnit.CaseTemplate, async: false
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import JsRoutesExample.Router.Helpers
      import JsRoutesExample.IntegrationCase

      # The default endpoint for testing
      @endpoint JsRoutesExample.Endpoint

      hound_session

      setup tags do
        maximize_window current_window_handle
        :ok
      end
    end
  end
end
