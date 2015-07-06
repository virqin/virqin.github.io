'use strict'

window.myblogApp = angular.module("myblog", [
  "ngRoute"
  "ngAnimate"
])


myblogApp.directive 'markdown',->
  restrict:'EA'
  require: '?ngModel'
  link: (scope,element,attrs,ngModel)->
    scope.$watch (->ngModel.$modelValue),(newValue)->
      element.html  marked (if newValue then newValue else "# loading...")

myblogApp.directive 'markdowntext',->
  restrict:'EA'
  link: (scope,element,attrs)->
      element.html marked element.text()

myblogApp.config ($routeProvider, $locationProvider) ->
  $routeProvider.when("/",
    templateUrl: "/template/home.html"
  ).when("/post/:name",
    templateUrl: "/template/post.html"
  ).when("/page/:name",
    templateUrl: "/template/post.html"
  ).otherwise redirectTo: "/"
  # $locationProvider.html5Mode true


parseTitle = (data)->
  r=
    title:""
    category:""
    tag:""
    text:""
    url:""
    hide:""
  for line in data.split('\n')
    [key,value] = line.split(':')
    key = _.str.trim key
    value = _.str.trim value
    if r.hasOwnProperty(key) then r[key]=value
  return r

parseList = (data)->
  _.map data.split(/\n[\-=]+\n/),parseTitle


listCtrl = ($scope,$http)->
  window.w = $scope
  $http.get("/posts/list.md",cache:true).success (data)->
    $scope.blogList=_.filter(parseList(data),(it)-> it.hide!='true' )
listCtrl.$inject = ['$scope', '$http']

parsePost = (text)->
  flag = false
  head =""
  tail = ""
  for line in text.split('\n')
    if /[\-=]+/.test(line) 
     flag=true
    if flag 
      tail+= '\n'+line
    else
      head+= '\n'+line
  post = parseTitle head
  post.text = tail
  if post.hide=="true" then return 
  return post


postCtrl = ($scope,$http,$routeParams)->
  $scope.name = $routeParams.name
  $http.get('/posts/'+$scope.name).success (data)->
    $scope.post = parsePost(data)
postCtrl.$inject = ['$scope', '$http','$routeParams']


homeCtrl = ($scope)->
homeCtrl.$injector = ['$scope']


myblogApp.controller 'listCtrl',listCtrl
myblogApp.controller 'postCtrl',postCtrl
myblogApp.controller 'homeCtrl',homeCtrl

