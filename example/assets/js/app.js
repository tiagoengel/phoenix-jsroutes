var container = document.getElementById('routes-container');

var routes = window.PhoenixJsRoutes;

for (var routeName in routes) {
  if (routeName !== 'noConflict' && routes.hasOwnProperty(routeName)) {

    var li = document.createElement('li');
    var routeFn = routes[routeName];
    var args = [];
    for (var i = 0; i <= routeFn.length; i++) {
      args.push(i);
    }
    li.id = routeName;

    var spanName = document.createElement('span');
    spanName.innerHTML = routeName;
    var spanRoute = document.createElement('span');
    spanRoute.innerHTML = routeFn.apply(null, args);

    li.appendChild(spanName)
    li.appendChild(spanRoute)
    container.appendChild(li);
  }
}
