@RobotIndexCtrl = ($scope, $http) ->
  $http.get('/robots').success (data)->
    $scope.robots = data

  $scope.robotDetail = (robotId) ->
    window.location = "#/robots/" + robotId

@RobotDetailCtrl = ($scope, $http, $routeParams) ->
  $http.get('/robots/' + $routeParams.robotId).success (data)->
    $scope.robot = data


