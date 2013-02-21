#= require 'vendor/jquery.min.js'
#= require 'vendor/angular.min.js'
#= require 'vendor/bootstrap.min.js'

@RobotsCtrl = ($scope, $http) ->
  $http.get('/robots').success (data)->
    $scope.robots = data
