``` shell
$ git add index.html
$ git commit -m "first commit"
$ git branch -M main

$ git push -u origin main
```
### 第一次将远程代码同步到本地
``` shell
$ git init
$ git config --global user.email "xxx"
$ git config --global user.name "xxx"
$ git remote add origin https://github.com/xxx/xxx.github.io.git
$ git pull origin main # 将远程库的文件同步到本地

```

### 其他设置
``` shell
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy
$ git config --global http.sslVerify false

```

### 加速git访问
> https://github.com/dotnetcore/fastgithub/releases


> 清除配置中纪录的用户名和密码，下次提交代码时会让重新输入账号密码：
``` shell
git config --system --unset credential.helper
```
> 查看git配置信息
``` shell
git config --list
```
> 执行命令之后，再次pull或push时会缓存输入的用户名和密码：
``` shell
git config --global credential.helper store
```
> 清除git缓存中的用户名的密码
``` shell
git credential-manager uninstall
```

``` shell
# 第一次免密拉取代码
 git config --global user.email "xxx@xxx.com"
 git config --global user.name "xxx"
 git init
 git remote add origin https://github.com/icymon/icymon.github.io.git
 git config --global --unset http.proxy
 git config --global --unset https.proxy
 git config --global http.sslVerify false
 git pull origin main
 
# commit时sign with a code，按照操作即可

```


### 免密登录

> 前提：第一次将远程代码同步到本地；否则“git remote  set-url origin [ssh地址]”回报错。

``` shell
ssh-keygen -t rsa -C "xxx@xx.com"
```
进入 ～/.ssh 目录，复制id_rsa.pub文件内容

登录 GitHub，进入 「Personal settings」，选择 「SSH and GPG keys 」选项：
Title 随意填写，Key中粘贴id_rsa.pub文件内容
``` shell
git remote -v  # 命令查看关联状态
```
在代码仓库复制ssh地址，然后在本地执行：
``` shell
git remote  set-url origin [ssh地址]
```
提交前确认下就行
``` shell
git push -u origin main
```

### [【杂谈】github page编写md文件，渲染时直接显示文件内容，处理办法](https://blog.csdn.net/C2681595858/article/details/88066775)
原文：[【杂谈】github page编写md文件，渲染时直接显示文件内容，处理办法](https://blog.csdn.net/C2681595858/article/details/88066775)
