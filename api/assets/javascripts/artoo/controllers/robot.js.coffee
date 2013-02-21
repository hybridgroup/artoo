@RobotIndexCtrl = ($scope, $http) ->
  $http.get('/robots').success (data)->
    $scope.robots = data

@RobotDetailCtrl = ($scope, $http, $routeParams) ->
  $http.get('/robots/' + $routeParams.robotId).success (data)->
    $scope.robot = data


