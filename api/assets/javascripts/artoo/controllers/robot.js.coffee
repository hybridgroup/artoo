window.driversWithOutput = ["Pinger", "Pinger2", "ardrone_navigation", "wiiclassic"]

@RobotIndexCtrl = ($scope, $http, $location, $route) ->
  $http.get('/robots').success (data)->
    $scope.robots = data
  $scope.robotDetail = (robotId) ->
    $location.path "/robots/" + robotId

@RobotDetailCtrl = ($scope, $http, $routeParams, $location) ->
  $http.get('/robots/' + $routeParams.robotId).success (data)->
    $scope.robot = data

  $scope.getDeviceDetail = (deviceId) ->
    $http.get('/robots/' + $scope.robot.name + "/devices/" + deviceId).success (data)->
      $scope.deviceDetail = data
      device.console()

  $scope.driverHasOutput = (driverId)->
    true if $.inArray(driverId, window.driversWithOutput) != -1

  device = console: ->
    window.ws.close() if window.ws
    wspath = "ws://" + location.host + "/robots/"
    window.ws = new WebSocket(wspath + $scope.robot.name + "/devices/" + $scope.deviceDetail.name + "/events")
    $(".console code").empty()
    ws.onmessage = (evt)->
      $(".console code").prepend(evt.data + "\n")

  $scope.isConnected = (connection) ->
    "connected" if  connection && connection.connected


