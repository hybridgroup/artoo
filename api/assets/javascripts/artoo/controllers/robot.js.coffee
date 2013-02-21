@RobotIndexCtrl = ($scope, $http, $location) ->
  $http.get('/robots').success (data)->
    $scope.robots = data

  $scope.robotDetail = (robotId) ->
    $location.path "/robots/" + robotId

@RobotDetailCtrl = ($scope, $http, $routeParams) ->
  $http.get('/robots/' + $routeParams.robotId).success (data)->
    $scope.robot = data


