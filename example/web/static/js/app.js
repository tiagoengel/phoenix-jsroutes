let container = document.getElementById('routes-container');

let routes = window.PhoenixJsRoutes;

Object.keys(routes).forEach(routeName => {
  if (routeName === 'noConflict') return;
  let li = document.createElement('li');
  let routeFn = routes[routeName];
  let args = [];
  for (let i = 0; i <= routeFn.length; i++) {
    args.push(i);
  }
  li.id = routeName;

  let spanName = document.createElement('span');
  spanName.innerHTML = routeName;
  let spanRoute = document.createElement('span');
  spanRoute.innerHTML = routeFn.apply(null, args);

  li.appendChild(spanName)
  li.appendChild(spanRoute)
  container.appendChild(li);
});
