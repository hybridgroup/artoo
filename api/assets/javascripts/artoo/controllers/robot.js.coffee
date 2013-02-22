@RobotIndexCtrl = ($scope, $http, $location) ->
  $http.get('/robots').success (data)->
    $scope.robots = data
  $scope.robotDetail = (robotId) ->
    $location.path "/robots/" + robotId

@RobotDetailCtrl = ($scope, $http, $routeParams, $location) ->
  $http.get('/robots/' + $routeParams.robotId).success (data)->
    $scope.robot = data
  $scope.deviceDetail = (robotId, deviceId) ->
    $location.path "/robots/" + robotId + "/devices/" + deviceId
  $scope.isConnected = (connection) ->
    "connected" if connection.connected

@RobotDeviceDetailCtrl = ($scope, $http, $routeParams) ->
  $http.get('/robots/' + $routeParams.robotId + "/devices/" + $routeParams.deviceId).success (data)->
    console.log data
    $scope.deviceDetail = data

