/*eslint-disable*/
// jshint ignore: start
/** <% import PhoenixJsrouter %>
 * DO NOT MODIFY!
 * This file was automatically generated and will be overwritten in the next build
 * <% {year, month, day} = :erlang.date %> <% {hour, minutes, seconds} = :erlang.time %>
 * generated on <%= year %>-<%= month %>-<%= day %> <%= hour %>:<%= minutes %>:<%= seconds %>
 */

(function (name, definition){
   if (typeof define === 'function'){
     define(definition);
   } else if (typeof module !== 'undefined' && module.exports) {
     module.exports = definition();
   } else {
     var theModule = definition(), global = this, old = global[name];
     theModule.noConflict = function () {
       global[name] = old;
       return theModule;
     };
     global[name] = theModule;
   }
 })('jsrouter', function () {
   return { <%= for route <- routes do %>
     <% fn_name = function_name(route) %>
     <%= fn_name %>: function <%= fn_name %>(<%= function_params(route) %>) {
       return <%= function_body(route) %>;
     }, <% end %>
   }
 });
