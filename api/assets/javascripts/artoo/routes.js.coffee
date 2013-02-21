# Routes
angular.module("artoo", []).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/robots",
    templateUrl: "/partials/robot-index.html"
    controller: RobotIndexCtrl
  ).otherwise redirectTo: "/robots"
]

