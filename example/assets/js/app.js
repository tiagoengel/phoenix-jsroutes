import * as routes from "./phoenix-jsroutes";

const container = document.getElementById('routes-container');

Object.keys(routes).forEach((routeName) => {
  if (routes.hasOwnProperty(routeName)) {
    const li = document.createElement('li');
    const routeFn = routes[routeName];
    const args = [];
    for (let i = 0; i <= routeFn.length; i++) {
      args.push(i);
    }
    li.id = routeName;

    const spanName = document.createElement('span');
    spanName.innerHTML = routeName;
    const spanRoute = document.createElement('span');
    spanRoute.innerHTML = routeFn.apply(null, args);

    li.appendChild(spanName)
    li.appendChild(spanRoute)
    container.appendChild(li);
  }
});
