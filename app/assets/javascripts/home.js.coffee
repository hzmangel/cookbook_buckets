'use strict'

# Create module
cookbookApp = angular.module('cookbookApp', [
  'ngResource'
  'ngTable'
  'ui.bootstrap'
])

# Resource for cookbook API
cookbookApp.factory 'Cookbooks', [
  '$resource'
  ($resource) ->
    $resource 'cookbooks/:cookbookId', { cookbookId: '@id' },
      update:
        method: 'PATCH'
]

# Main controller
cookbookApp.controller 'CookbookListController', [
  '$scope'
  '$log'
  '$filter'
  '$uibModal'
  'NgTableParams'
  ($scope, $log, $filter, $uibModal, NgTableParams) ->
    $scope.cookbook_list = []
    $scope.selected_cookbook = {}
    # TODO: paginate with NgTableParams

    $scope.tableParams = new NgTableParams({
      count: 1
      sorting: name: 'desc'
    },
      total: $scope.cookbook_list.length
      getData: ($defer, params) ->
        $defer.resolve(
          $filter('orderBy')($scope.cookbook_list, params.orderBy())
        )
        return
    )

    $scope.popularCookbookList = ->
      $scope.cookbooks = Cookbooks.query()
      $scope.selected_idx = -1

    $scope.new = ->
      $scope.cookbook = new Cookbooks({})
      $scope.selected_idx = -1
      $scope.openModal('new')

    $scope.edit = (idx) ->
      $scope.cookbook = angular.copy $scope.cookbooks[idx]
      $scope.selected_idx = idx
      $scope.openModal('edit')

    $scope.delete = (idx) ->
      $scope.cookbook = $scope.cookbooks[idx]
      $scope.cookbook.$delete ( ->
        $scope.cookbooks = Cookbooks.query()
        $scope.notification = {
            type: 'success'
            msg: 'Delete Successfully'
          }
      ), (errorResponse) ->
        $scope.notification = {
            type: 'error'
            msg: errorResponse.data.message
          }
        return

    $scope.openModal = (modal_type) ->
      modalInstance = $uibModal.open(
        animation: true
        templateUrl: 'cookbookForm.html'
        controller: 'CookbookModalInstanceCtrl'
        resolve:
          cookbook: ->
            $scope.cookbook
          modal_type: ->
            modal_type
      )

      modalInstance.result.then (cookbook) ->
        if $scope.selected_idx != -1
          console.log $scope.cookbook
          $scope.cookbook.$update ( ->
            $scope.cookbooks = Cookbooks.query()
            $scope.notification = {
                type: 'success'
                msg: 'Update Successfully'
              }
          ), (errorResponse) ->
            $scope.notification = {
                type: 'error'
                msg: errorResponse.data.message
              }
            return
        else
          $scope.cookbook.$save ((cookbook, req) ->
            $scope.cookbooks = Cookbooks.query()
            $scope.notification = {
                type: 'success'
                msg: 'Created Successfully'
              }
          ), (errorResponse) ->
            $scope.notification = {
                type: 'error'
                msg: errorResponse.data.message
              }
            return
        return
      return

    return
]

# Modal controller
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
