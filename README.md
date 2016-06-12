# PhoenixJsroutes

![build](https://travis-ci.org/tiagoengel/phoenix-jsroutes.svg?branch=master)

Brings phoenix router helpers to your javascript code.

This project consist of a mix compiler task that generates a javascript
module containing helpers to access your server routes.

# Installation

Add the latest version to your ```mix.exs``` file:
```elixir
def deps do
  [{:phoenix_jsroutes, "~> 0.0.1"}]
end
```

# Getting started



## TODO

- [X] Test the generated js module.
- [X] Use the current phoenix application routes to generate the file
- [ ] Test the task with a real phoenix application
- [X] Allow to configure a list of "scopes" to generate the routes only for these scopes
- [X] Get the output path from a configuration
- [ ] Add instructions on how to make the process automatically
- [ ] Add support to umbrella applications
- [ ] Get the template from a configuration

## Contributors

Special thanks to this guys who helped me starting this project.

<br/>[Marcio Junior](https://github.com/marcioj)
<br/>[Horacio Fernandes](https://github.com/horaciosystem)
<br/>[Diogo Kersting](https://github.com/diogovk)
<br/>[Paulo](https://github.com/paaulo)
