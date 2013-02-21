#= require 'vendor/jquery.min.js'
#= require 'vendor/angular.min.js'
#= require 'vendor/bootstrap.min.js'
#= require 'artoo/routes.js.coffee'
#= require 'artoo/controllers/robot.js.coffee'

angular.module("link", []).directive "activeLink", ["$location", (location) ->
  restrict: "A"
  link: (scope, element, attrs, controller) ->
    clazz = attrs.activeLink
    path = attrs.href
    path = path.substring(1) #hack because path does bot return including hashbang
    scope.location = location
    scope.$watch "location.path()", (newPath) ->
      if path is newPath
        element.addClass clazz
      else
        element.removeClass clazz
]
