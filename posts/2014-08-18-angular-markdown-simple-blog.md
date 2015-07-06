dsf.. 首先博客托管使用github page服务。因为github page只支持纯静态页面，或者使用Jekyll模板引擎生成页面。
title: 基于angularjs和markdown的简易博客
description: 
category: web
tag: github angularjs markdown
-----------
首先博客托管使用github page服务。 因为github page只支持纯静态页面，或者使用Jekyll模板引擎生成页面。

网站找到的使用github page教程大多是使用后者，由于Jekyll安装使用需要ruby基础，所以我们换种思路，用angularjs写single page app.把jekyll做的工作放到浏览器来做。

系统 ubuntu desktop 64位【 Linux real 3.13.0-33-generic #58-Ubuntu SMP Tue Jul 29 16:45:05 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux )

首先安装 `nodejs sudo apt-get install nodejs npm`

然后安装包管理工具 `bower sudo npm install -g bower`

安装coffeescript, `sudo npm install -g coffee-script`

然后安装js库 `bower install angularjs angular-animate angular-route bootstrap jquery markdown-js ngAnimate underscore underscore.string`

有几个会安装失败，可直接去github上 clone 源代码


简单介绍下每个库的用途：

-    angularjs: google的MVVM框架。
-    bootstrap: 基础界面库
-    underscore,underscore.string: 工具库
-    nganimate: angularjs的一些动画
    
装完之后的库放在 bower_conponents

然后建立 posts,static,template,分别存放文章，静态文件，模板

然后建立测试文章 2014-08-08-name-example.md,内容

    title: 标题
    description: 描述
    category: 分类
    tag:标签
    -------
    内容

######格式说明：
用—---或者======分割 描述信息和内容， description,description,tag等目前暂时无用，待下个版本改进

然后借助一个python脚本

    import os,re
    
    def get_head(name):
        head = []
        try:
            if not re.match(r'^\d{4}-\d\d-\d\d-',name) : 
                print('ignore file '+name)
                return None
            for i in open(name).read().splitlines():
                if re.match(r'^[\-=]*$',i):break
                head.append(i)
            head.append('url: %s'%name)
            print('success name'+name)
            return '\n'.join(head)
        except Exception as e:
            print('error file '+name)
            print(e)
            return None
    
    
    file_list = os.listdir('.')
    head = filter(None,map(get_head,file_list))
    open('list.md','w').write('\n-------\n'.join(head))
    

把文章的前面的介绍信息拼接到一起生成list.md
然后开始写 index.html

    <!DOCTYPE HTML>
    <html ng-app="myblog">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
        <link href="/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css">
        <link href="/bower_components/ngAnimate/css/ng-animation.css" rel="stylesheet" type="text/css">
    
        <link href="/static/myblog.css" rel="stylesheet" type="text/css">
    
        <title>wangkechun</title>
    
    
    
    </script>
    
    </head>
    　　
    <body>
        <nav class="navbar navbar-default navbar-fixed-top" style="opacity: .9" role="navigation">
            <div class="container-fluid">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/">wangkechun</a>
                </div>
    
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="active"><a href="#">Blog</a></li>
                        <li><a href="https://github.com/wangkechun" target="_blank">GitHub</a></li>
                    </ul>
                </div><!-- /.navbar-collapse -->
            </div><!-- /.container-fluid -->
        </nav>
    
        <div class="container center-block" ng-controller="listCtrl">
            <div class="row" style="padding-top: 70px">
                <div class="col-md-4 col-sm-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                Blog
                            </h3>
                        </div>
                    </div>
                    <ul class="list-group ng-cloak">
                        <li class="list-group-item scale-fade" ng-repeat="post in blogList"><a ng-href="/#/post/{{post.url}}">{{post.title}}</a></li>
                    </ul>
                </div>
    
                <div class="col-md-7 "  >
                    <div ng-view class="post-animate"></div>
                </div>
            </div>
        </div>
        <script src="/bower_components/jquery/dist/jquery.min.js"></script>
        <script src="/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
        <script src="/bower_components/angularjs/angular.min.js"></script>
        <script src="/bower_components/markdown-js/dist/markdown.min.js" ></script>
        <script src="/bower_components/angular-route/angular-route.min.js"></script>
        <script src="/bower_components/angular-animate/angular-animate.min.js"></script>
        <script src="/bower_components/underscore/underscore.js"></script>
        <script src="/bower_components/underscore.string/dist/underscore.string.min.js"></script>   
        <script src="/static/myblog.js"></script>
    </body>  
    </html>

引入 jquery的原因， bootstrap的导航在手机上会折叠，折叠动作依赖于bootstrap.js,bootstrap.js依赖于jquery

post.html 文章页面的模板

    <div ng-controller="postCtrl" class="ng-cloak">
        <h1>{{post.title}}</h1>
        <div markdown ng-model="post.text"> </div>
    </div>


home.html 首页模板

    <div ng-controller="homeCtrl" class="ng-cloak">
        <div markdowntext>
    ## 欢迎光临我的小站。
        </div>
    </div>


然后开始 myblog.coffee
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
          element.html  markdown.toHTML (if newValue then newValue else "# loading...")
    
    
    
    myblogApp.directive 'markdowntext',->
      restrict:'EA'
      link: (scope,element,attrs)->
          element.html markdown.toHTML element.text()
    
    myblogApp.config ($routeProvider, $locationProvider) ->
      $routeProvider.when("/",
        templateUrl: "/template/home.html"
      ).when("/post/:name",
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
    
    # shoplist.html
    
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
          tail+= '\n'+line+'\n'
        else
          head+= '\n'+line+'\n'
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
    


这里涉及到两个angularjs指令

- markdown.toHTML 是markdown.js的函数，把一段文字变成html
- markdowntext 把标签内部的文本变成markdown
- markdown 把$scope.text的文本转为markdown
- _.str.trim是underscore.string里面的函数，去除字符串两侧的空格 
- .map ,_filter 则是 underscore的函数
listCtrl.inject = ['scope', '$http'] 是防止代码压缩导致注入失败， 因为github page 会自动压缩css,js

然后 运行 python -m SimpleHTTPServer 启动服务器 查看效果
此时网站应该可以顺利运行，准备部署github
部署参照 http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html

至此，最简单的Blog就算搭建完成了。 最终效果 http://blog.hi-hi.cn
