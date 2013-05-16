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
  $scope.executeCommand = (deviceId, command) ->
    params      = $( "#appendedDropdownButton" ).val()
    post_params = {}
    post_params = "{\"params\": [#{params}]}" unless params == ""
    $http.post('/robots/' + $scope.robot.name + "/devices/" + deviceId + "/commands/" + command, post_params).success (data)->
      true

  device = console: ->
    window.ws.close() if window.ws
    wspath = "ws://" + location.host + "/robots/"
    window.ws = new WebSocket(wspath + $scope.robot.name + "/devices/" + $scope.deviceDetail.name + "/events")
    $(".console code").empty()
    ws.onmessage = (evt)->
      $(".console code").prepend(evt.data + "\n")

  $scope.isConnected = (connection) ->
    "connected" if  connection && connection.connected
