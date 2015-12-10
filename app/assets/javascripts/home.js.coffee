'use strict'

angular.module('cookbookApp', ["ngTable", 'ui.bootstrap']).
controller 'CookbookListController', [
  '$scope'
  '$log'
  '$uibModal'
  'NgTableParams'
  ($scope, $log, $uibModal, NgTableParams) ->
    $scope.cookbook_list = []
    $scope.selected_cookbook = {}
    # TODO: paginate with NgTableParams
    $scope.tableParams = new NgTableParams({})

    $scope.popularCookbookList = ->
      $scope.selected_idx = -1
      $scope.cookbook_list = [
        {id: 1, name: "Cookbook_1", desc: "Desc of Cookbook_1"},
        {id: 2, name: "Cookbook_2", desc: "Desc of Cookbook_2"},
        {id: 3, name: "Cookbook_3", desc: "Desc of Cookbook_3"}
      ]

    $scope.new = ->
      $scope.selected_cookbook = {}
      $scope.selected_idx = -1
      $scope.openModal('new')

    $scope.edit = (idx) ->
      $scope.selected_cookbook = angular.copy $scope.cookbook_list[idx]
      $scope.selected_idx = idx
      $scope.openModal('edit')

    $scope.delete = (idx) ->
      # TODO: Call delete API
      $log.info idx

    $scope.openModal = (modal_type) ->
      modalInstance = $uibModal.open(
        animation: true
        templateUrl: 'cookbookForm.html'
        controller: 'CookbookModalInstanceCtrl'
        resolve:
          cookbook: ->
            $scope.selected_cookbook
          modal_type: ->
            modal_type
      )
      modalInstance.result.then (cookbook) ->
        if $scope.selected_idx != -1
          # TODO: Call update API
          $scope.cookbook_list[$scope.selected_idx] = cookbook
        else
          # TODO: Call create API
          $scope.cookbook_list.push(cookbook)
        return
      return

    return
]

angular.module('cookbookApp').
controller 'CookbookModalInstanceCtrl',
($scope, $log, $uibModalInstance, cookbook, modal_type) ->

  $scope.cookbook = cookbook
  $scope.modal_type = modal_type

  $scope.ok = ->
    $uibModalInstance.close $scope.cookbook
    return

  $scope.cancel = ->
    $uibModalInstance.dismiss 'cancel'
    return

  return
