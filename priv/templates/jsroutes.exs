/*eslint-disable*/
// jshint ignore: start
/** <% import PhoenixJsroutes %>
 * DO NOT MODIFY!
 * This file was automatically generated and will be overwritten in the next build
 */
<%= for route <- routes do %> <% fn_name = function_name(route) %>
export function <%= fn_name %>(<%= function_params(route) %>) {
  return <%= function_body(route) %>;
}
<% end %>

