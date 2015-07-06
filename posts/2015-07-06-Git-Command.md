title: Git 常用操作
description:
category: Git
tag: Git
-------------------------

###同步子模块地址命令
`git submodule sync --recursive`

###同步子模块命令
`git submodule update --init --recursive`

###全部更新
`git submodule foreach --recursive git pull origin master`

###子模块的索引冲突
`git mergetool subname`
选择冲突解决方案

---

##查看分支：
###查看本地分支：
`$ git branch`
###查看远程分支
`$ git branch -r`


##创建分支：
###创建本地分支
####建立分支后，仍停留在当前分支
`$ git branch branchName`
####切换分支
`git checkout branchName`
###创建分支后切换到新分支
`$ git checkout -b branchName`

##提交分支：
###提交到远程分支
`$ git commit -a -m 'my new branch'`

`$ git push origin branchName:branchName`
###如果想把本地的某个分支mybranch提交到远程仓库，并作为远程仓库的master分支
`$ git push origin mybranch:master`

##删除分支：
###删除远程分支
`$ git push origin :branchName`
###删除本地分支，强制删除用-D
`$ git branch -d branchName`

##合并分支
###将分支branchName和当前所在分支合并
`$ git merge branchName`

##标记tag
###对当前分支打tag：
`$ git tag tagContent`
###然后push到远程即可：
`$ git push origin BranchName:BranchName`

---
