angular.module('loomioApp').directive 'authSignupForm', (AppConfig, AuthService, KeyEventService) ->
  scope: {user: '='}
  templateUrl: 'generated/components/auth/signup_form/auth_signup_form.html'
  controller: ($scope) ->
    $scope.pendingIdentity = AppConfig.pendingIdentity
    $scope.recaptchaKey    = AppConfig.recaptchaKey
    $scope.name  = $scope.user.name
    $scope.email = $scope.user.email

    $scope.helperBot =
      constructor: {singular: 'user'}
      avatarKind: 'uploaded'
      avatarUrl:  '/img/mascot.png'

    $scope.back = ->
      $scope.user.emailStatus = null

    $scope.submit = ->
      $scope.$emit 'processing'
      $scope.user.name  = $scope.name
      $scope.user.email = $scope.email
      AuthService.signUp($scope.user).finally -> $scope.$emit 'doneProcessing'

    KeyEventService.submitOnEnter($scope, anyEnter: true)
    $scope.$emit 'focus'
