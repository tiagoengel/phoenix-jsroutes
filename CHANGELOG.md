# Changelog

## 2.0.0

**Breaking:**

- Removed support for AMD and global build (`window.PhoenixJSRoutes`).
- Removed the default export from the js file. Please replace `import routes from 'phoenix-jsroutes'` with `import * as routes from 'phoenix-jsroutes'`.

From now on the javascript file is generated using ES6 modules syntax and you need a bundler able to transpile it.
If you are using the default Phoenix config with `webpack` and the default config for this project, there is no need to do anything. Just import the routes file
in your code as you would normally do.

If you are generating the file in a location where `webpack` will not compile it, e.g. `priv/static` you need to update it to `assets/js`.

## 1.0.0

**Breaking:**

- Support for phoenix 1.3 and 1.4.
- Moved default outuput folder from "web/static/js" to "assets/statics/js".
