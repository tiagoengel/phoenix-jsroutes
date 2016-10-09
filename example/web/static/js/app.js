import routes from "./phoenix-jsroutes";

let container = document.getElementById('routes-container');

Object.keys(routes).forEach(routeName => {
  let li = document.createElement('li');
  let routeFn = routes[routeName];
  let args = Array.from(Array(routeFn.length).keys());
  li.id = routeName;

  let spanName = document.createElement('span');
  spanName.innerHTML = routeName;
  let spanRoute = document.createElement('span');
  spanRoute.innerHTML = routeFn.apply(null, args);

  li.appendChild(spanName)
  li.appendChild(spanRoute)
  container.appendChild(li);
});
