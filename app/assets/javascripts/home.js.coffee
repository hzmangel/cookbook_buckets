'use strict'

# Create module
cookbookApp = angular.module('cookbookApp', [
  'ngResource'
  'ngTable'
  'ngTagsInput'
  'ui.bootstrap'
  'ui-notification'
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
  '$filter'
  '$uibModal'
  'NgTableParams'
  'Notification'
  'Cookbooks'
  ($scope, $filter, $uibModal, NgTableParams, Notification, Cookbooks) ->
    $scope.cookbooks = []
    $scope.cookbook = {}
    # TODO: paginate records with NgTableParams

    $scope.tableParams = new NgTableParams({
      sorting:
        name: 'desc' # Sorting by name.desc by default
    },
      total: $scope.cookbooks.length
      getData: ($defer, params) ->
        $defer.resolve(
          $filter('orderBy')($scope.cookbooks, params.orderBy())
        )
        return
    )

    $scope.popularCookbookList = ->
      $scope.cookbooks = Cookbooks.query()
      $scope.selected_id = 0

    $scope.new = ->
      $scope.selected_id = 0
      $scope.cookbook = new Cookbooks({})
      $scope.openModal('new')

    $scope.edit = (rcd_id) ->
      $scope.selected_id = rcd_id
      $scope.cookbook = $filter('filter')($scope.cookbooks, id: $scope.selected_id)[0]
      console.log rcd_id
      console.log $scope.cookbook
      $scope.openModal('edit')

    $scope.delete = (rcd_id) ->
      $scope.cookbook = $scope.cookbooks[idx]
      $scope.cookbook.$delete ( ->
        $scope.cookbooks = Cookbooks.query()
        Notification.success('Record deleted Successfully')
      ), (errorResponse) ->
        Notification.error(errorResponse.data.message)
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
        if $scope.selected_id != 0
          cookbook.$update ( ->
            $scope.cookbooks = Cookbooks.query()
            Notification.success('Record updated Successfully')
          ), (errorResponse) ->
            Notification.error(errorResponse.data.message)
            return
        else
          cookbook.$save ((cookbook, req) ->
            $scope.cookbooks = Cookbooks.query()
            Notification.success('Record created Successfully')
          ), (errorResponse) ->
            Notification.error(errorResponse.data.message)
            return
        return
      return

    return
]

# Modal controller
angular.module('cookbookApp').
controller 'CookbookModalInstanceCtrl',
($scope, $uibModalInstance, cookbook, modal_type) ->

  $scope.cookbook = cookbook
  $scope.modal_type = modal_type

  # console.log cookbook
  # console.log $scope.cookbook

  $scope.ok = ->
    $uibModalInstance.close $scope.cookbook
    return

  $scope.cancel = ->
    $uibModalInstance.dismiss 'cancel'
    return

  return
