# PhoenixJsroutes

![Elixir CI](https://github.com/tiagoengel/phoenix-jsroutes/workflows/Elixir%20CI/badge.svg)

Brings phoenix router helpers to your javascript code.

This project is a mix compiler task that generates a javascript module containing helpers to access your server routes.

## Installation

Add the latest version to your `mix.exs` file:
```elixir
def deps do
  [{:phoenix_jsroutes, "~> 1.0.0"}]
end
```

## Compatibility

| Version | Phoenix Version |
| ------- | --------------- |
| >= 1.0  | >= 1.3          |
| <= 0.4  | <= 1.2          |

## Getting started

Add the ```jsroutes``` compiler to the list of compilers in your project.

```elixir
def project do
    [app: :jsroutes_test,
    ...
    compilers: [:phoenix, :gettext] ++ Mix.compilers ++ [:jsroutes]
    ...]
end
```

**This compiler should be placed after the elixir compiler, this is important because your router module should be already compiled when this compiler runs**

After that, if you run ```mix compile``` the file ```assets/js/phoenix-jsroutes.js``` will be generated.

You can clean up the generated file by running ```mix clean```.

The location and file name can be changed (see Configuration section bellow), keep in mind that if you change it, `mix clean` will not be able to remove the old file. It's recommended to always run mix clean before you update this config.

### Using the javascript helpers

The code is generated using ES6 modules syntax and work with the default Phoenix config using webpack.

The functions are generated with different names from the ones in the server in order to follow javascript best practices. For example:

```
user_path(:index)                => userIndex()
user_path(:create)               => userCreate()
user_path(:update, 1)            => userUpdate(1)
user_friends_path(:update, 1, 2) => userFriendsUpdate(1, 2)
```

#### Usage

```javascript
// app.js
import * as routes from './phoenix-jsroutes'
routes.userIndex(); // /users
routes.userCreate(); // /users
routes.userUpdate(1); // /users/1
routes.userFriendsUpdate(1, 2); // /users/1/friends/2
```

You can also import only the routes you need

```javascript
// app.js
import { userIndex, userUpdate } from './phoenix-jsroutes';
userIndex();
userUpdate(1);
```

## Live reload

If you want the javascript module to be generated automatically when your router changes, just add this compiler to the list of `reloadable compilers`.

```elixir
# config/dev.exs

config :my_app, MyApp.Endpoint,
  http: [port: 4000],
  ...
  reloadable_compilers: [:gettext, :phoenix, :elixir, :jsroutes]
```

NOTE: if you are using version >= 1.5 of Phoenix you might need to reload the page once or twice for
changes to take effect.

## Configuration

Key | Type | Default | Description  |
| --- | --- | --- | --- |
output_folder | String | assets/static/js | Sets the folder used to generate files
include | Regex | nil | Will include only routes matching this regex
exclude | Regex | nil | Will include only routes not matching this regex

Configurations should be added to the key ```:jsroutes``` in your application.
```elixir
config :my_app, :jsroutes,
  output_folder: "assets/static/js",
  include: ~r[/api],
  exclude: ~r[/admin]
```

## Contributing

Contributions are very welcome. If you want to contribute to this project first
open an issue so we can discuss your ideas, if you're confident in implementing it, fork the project and create a pull request. Thank's in advance :).

## Contributors

Special thanks to the amazing people who have helped me start this project.

<br/>[Marcio Junior](https://github.com/marcioj)
<br/>[Horacio Fernandes](https://github.com/horaciosystem)
<br/>[Diogo Kersting](https://github.com/diogovk)
<br/>[Paulo](https://github.com/paaulo)
