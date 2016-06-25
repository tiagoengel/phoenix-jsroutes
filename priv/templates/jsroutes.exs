/*eslint-disable*/
// jshint ignore: start
/** <% import PhoenixJsroutes %>
 * DO NOT MODIFY!
 * This file was automatically generated and will be overwritten in the next build
 */

(function (name, definition){
   if (typeof define === 'function'){
     define(definition);
   } else if (typeof module !== 'undefined' && module.exports) {
     var moduleDef = definition();
     for (var key in moduleDef) {
       if (moduleDef.hasOwnProperty(key)) {
         module.exports[key] = moduleDef[key];
       }
     }
   } else {
     var theModule = definition(), global = this, old = global[name];
     theModule.noConflict = function () {
       global[name] = old;
       return theModule;
     };
     global[name] = theModule;
   }
 })('PhoenixJsRoutes', function () {
   return { <%= for route <- routes do %>
     <% fn_name = function_name(route) %>
     <%= fn_name %>: function <%= fn_name %>(<%= function_params(route) %>) {
       return <%= function_body(route) %>;
     }, <% end %>
   }
 });
