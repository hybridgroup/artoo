@RobotIndexCtrl = ($scope, $http) ->
  $http.get('/robots').success (data)->
    $scope.robots = data

