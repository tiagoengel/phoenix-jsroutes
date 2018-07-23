# JsRoutesExample

Example application to show the phoenix-jsroutes compiler in action and for
running integration tests.

If you want to use this as base for your project take the configuration with a grain
of salt. This project has some hacks and configurations that you would not want
to use in a normal app. Most of it is due to the travis environment.

# Running

First run `mix deps.get && npm install` then `mix phx.server`

Navigate to `/` and you will see the routes defined in the `router.ex`.

Change the `router.ex` file and refresh the page the see the live reload compiler in action.

# Tests

You will need to install and start phantomjs. `npm install -g phantomjs && phantomjs -w`

Then run `WEBDRIVER=phantomjs MIX_ENV=test mix compile && mix test`
