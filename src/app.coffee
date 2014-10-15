fs = require 'fs'

app = angular.module('app',[])
app.controller 'AppController',
  class AppController
    constructor: ($scope) ->
      $scope.model = {}
      $scope.model.text = '--not loaded yet--'

      path = '/Volumes/HardDrive/Music/'

      fs.readdir path, (err, list) ->
        $scope.$apply( -> $scope.model.files = list )
