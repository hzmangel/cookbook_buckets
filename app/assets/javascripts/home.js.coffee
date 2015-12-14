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
      search:
        method: 'POST'
        params: {searchParams: '@searchParams'}
        url: '/cookbooks/search?:searchParams'
        isArray: true
]

# Directives for checkbox group
cookbookApp.directive 'checkList', ->
  {
    scope:
      list: '=checkList'
      value: '@'
    link: (scope, elem, attrs) ->

      handler = (setup) ->
        checked = elem.prop('checked')
        index = scope.list.indexOf(scope.value)
        if checked and index == -1
          if setup
            elem.prop 'checked', false
          else
            scope.list.push scope.value
        else if !checked and index != -1
          if setup
            elem.prop 'checked', true
          else
            scope.list.splice index, 1
        return

      setupHandler = handler.bind(null, true)
      changeHandler = handler.bind(null, false)
      elem.bind 'change', ->
        scope.$apply changeHandler
        return
      scope.$watch 'list', setupHandler, true
      return
  }

# Directives for file uploader to Qiniu
cookbookApp.directive 'fileModel', [
  '$parse'
  '$rootScope'
  '$http'
  ($parse, $rootScope, $http) ->
    {
      restrict: 'A'
      link: (scope, elem, attrs) ->
        model = $parse(attrs.fileModel)
        modelSetter = model.assign
        elem.bind 'change', (e) ->
          # var product_key = '/products/' + attrs.ngProductId;
          img_file = e.target.files[0]
          if img_file == undefined
            return false
          scope.imageUploaded = false
          $http.get('/upload_token').then (resp) ->
            form = new FormData
            form.append 'token', resp.data.token
            form.append 'file', img_file
            # form.append("key", product_key);

            console.log form

            $rootScope.loading = true
            $http.post('http://up.qiniu.com', form, headers: 'Content-Type': undefined).success (data) ->
              $rootScope.loading = false
              scope.imageUploaded = true
              scope.cookbook.image = 'http://7xitul.com1.z0.glb.clouddn.com/' + data.key
              return
            return
          return
        return
    }
]


# Main controller
cookbookApp.controller 'CookbookListController', [
  '$scope'
  '$http'
  '$filter'
  '$uibModal'
  'NgTableParams'
  'Notification'
  'Cookbooks'
  ($scope, $http, $filter, $uibModal, NgTableParams, Notification, Cookbooks) ->
    $scope.cookbooks = []
    $scope.cookbook = {}

    initialParams =
      count: 10
      sorting:
        name: 'asc'
    initialSettings =
      paginationMaxBlocks: 13
      paginationMinBlocks: 2
      total: $scope.cookbooks.length
      getData: ($defer, params) ->
        $defer.resolve(
          $filter('orderBy')($scope.cookbooks, params.orderBy()).slice((params.page() - 1) * params.count(), params.page() * params.count())
          params.total($scope.cookbooks.length)
        )
        return
    $scope.tableParams = new NgTableParams(initialParams, initialSettings)

    $scope.popularCookbookList = ->
      Cookbooks.query ((data) ->
        $scope.cookbooks = data
        return
      ), (error) ->
        Notification.error('Server error, please contact us')
        return

      $scope.selected_id = 0

    $scope.show = (rcd_id) ->
      $scope.selected_id = rcd_id
      $scope.cookbook = $filter('filter')($scope.cookbooks, id: $scope.selected_id)[0]
      $scope.openViewModal('edit')

    $scope.openViewModal = (modal_type) ->
      modalInstance = $uibModal.open(
        animation: true
        size: 'lg',
        templateUrl: 'cookbookShow.html'
        controller: 'CookbookViewModalInstanceCtrl'
        resolve:
          cookbook: ->
            $scope.cookbook
      )
      return

    $scope.new = ->
      $scope.selected_id = 0
      $scope.cookbook = new Cookbooks({})
      $scope.openRecordModal('new')

    $scope.edit = (rcd_id) ->
      $scope.selected_id = rcd_id
      $scope.cookbook = $filter('filter')($scope.cookbooks, id: $scope.selected_id)[0]
      $scope.openRecordModal('edit')

    $scope.delete = (rcd_id) ->
      $scope.cookbook = $filter('filter')($scope.cookbooks, id: rcd_id)[0]
      $scope.cookbook.$delete ( ->
        Cookbooks.query ((data) ->
          $scope.cookbooks = data
          Notification.success('Record deleted Successfully')
          return
        ), (error) ->
          Notification.error('Server error, please contact us')
          return

      ), (errorResponse) ->
        Notification.error(errorResponse.data.message)
        return

    $scope.openRecordModal = (modal_type) ->
      modalInstance = $uibModal.open(
        animation: true
        size: 'lg',
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
            Cookbooks.query ((data) ->
              $scope.cookbooks = data
              Notification.success('Record updated Successfully')
              return
            ), (error) ->
              Notification.error('Server error, please contact us')
              return
          ), (errorResponse) ->
            Notification.error(errorResponse.data.message)
            return
        else
          cookbook.$save ((cookbook, req) ->
            Cookbooks.query ((data) ->
              $scope.cookbooks = data
              Notification.success('Record created Successfully')
              return
            ), (error) ->
              Notification.error('Server error, please contact us')
              return
          ), (errorResponse) ->
            Notification.error(errorResponse.data.message)
            return
        return
      return


    # Search related
    $scope.search = ->
      $http(
        method: 'GET'
        url: '/materials.json').then ((response) ->
          $scope.openSearchModal(response.data)
          return
      ), (response) ->
        console.error response
        return


    $scope.openSearchModal = (materials) ->
      modalInstance = $uibModal.open(
        animation: true
        size: 'lg',
        templateUrl: 'cookbookSearch.html'
        controller: 'CookbookSearchModalInstanceCtrl'
        resolve:
          materials: ->
            materials
      )

      modalInstance.result.then (search_params) ->
        console.log search_params
        $scope.cookbooks = Cookbooks.search(searchParams: search_params)
        $scope.tableParams.reload()
        Notification.success('Search result returned')
      return

    return
]

# Modal controller
angular.module('cookbookApp').
controller 'CookbookModalInstanceCtrl',
($scope, $uibModalInstance, cookbook, modal_type) ->

  $scope.imageUploaded = true
  $scope.cookbook = cookbook
  if $scope.cookbook.materials == undefined
    $scope.cookbook.materials = []
  $scope.modal_type = modal_type

  $scope.ok = ->
    $uibModalInstance.close $scope.cookbook
    return

  $scope.cancel = ->
    $uibModalInstance.dismiss 'cancel'
    return

  $scope.addMaterial = ->
    $scope.cookbook.materials.push
      id: Date.now()
    return

  $scope.removeMaterial = (rcd_id) ->
    $scope.cookbook.materials = $scope.cookbook.materials.filter((element, i) ->
      if (element.id == rcd_id)
        element._destroy = true
      else
        element
    )
    return

  $scope.isShowingMaterial = (rcd) ->
    rcd._destroy == undefined

  return

# Search modal
angular.module('cookbookApp').
controller 'CookbookSearchModalInstanceCtrl',
($scope, $uibModalInstance, materials) ->

  $scope.materials = materials

  $scope.search_params = {}
  $scope.search_params.selected_materials = []

  $scope.search = ->
    $uibModalInstance.close $scope.search_params
    return

  $scope.cancel = ->
    $uibModalInstance.dismiss 'cancel'
    return

  return

# View modal
angular.module('cookbookApp').
controller 'CookbookViewModalInstanceCtrl',
($scope, $uibModalInstance, cookbook) ->

  $scope.cookbook = cookbook

  $scope.ok = ->
    $uibModalInstance.dismiss 'cancel'
    return

  return
