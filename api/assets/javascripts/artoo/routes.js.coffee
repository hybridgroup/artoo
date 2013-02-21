# Routes
angular.module("artoo", []).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when("/robots",
    templateUrl: "/partials/robot-index.html"
    controller: RobotIndexCtrl
  ).when("/robots/:robotId",
    templateUrl: "/partials/robot-detail.html"
    controller: RobotDetailCtrl
  ).otherwise redirectTo: "/robots"
]

