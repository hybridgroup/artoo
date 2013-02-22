# Routes
angular.module("artoo", []).config(["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/robots",
    templateUrl: "/partials/robot-index.html"
    controller: RobotIndexCtrl
  ).when("/robots/:robotId",
    templateUrl: "/partials/robot-detail.html"
    controller: RobotDetailCtrl
  ).when("/robots/:robotId/devices/:deviceId",
    templateUrl: "/partials/robot-device-detail.html"
    controller: RobotDeviceDetailCtrl
  ).otherwise redirectTo: "/robots"
]).directive("activeLink", ["$location", (location) ->
  restrict: "A"
  link: (scope, element, attrs, controller) ->
    clazz = attrs.activeLink
    path = attrs.$$element.find('a').attr('href')
    path = path.substring(1)
    scope.location = location
    scope.$watch "location.path()", (newPath) ->
      if path is newPath
        element.addClass clazz
      else
        element.removeClass clazz
])

