'use strict'

angular.module('cookbookApp', ["ngTable"]).
controller 'CookbookListController', [
  '$scope'
  'NgTableParams'
  ($scope, NgTableParams) ->
    $scope.cookbook_list = []
    # TODO: paginate with NgTableParams
    $scope.tableParams = new NgTableParams({})

    $scope.popularCookbookList = ->
      $scope.cookbook_list = [
        {id: 1, name: "Cookbook_1", desc: "Desc of Cookbook_1"},
        {id: 2, name: "Cookbook_2", desc: "Desc of Cookbook_2"},
        {id: 3, name: "Cookbook_3", desc: "Desc of Cookbook_3"}
      ]

    $scope.newCookbookModal = ->
      console.log 'asdfasdfsd'

    return
]
