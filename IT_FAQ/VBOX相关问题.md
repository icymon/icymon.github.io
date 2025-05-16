# VBOX相关问题

## 1、virtualbox_installation_failed

## 在我的电脑 -> 管理 -> 服务和应用程序 -> 服务 开启如下两个服务

* 1、Device Install Service.
* 2、Device Setup Manager.

## 安装过程可能提示需要安装python core

``` shell
pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple pywin32
```

## 2、virtualbox卸载

### 在控制面版中卸载

### 清理注册表，删除Oracle下面的virtualbox目录

### 删除用户目录下.VirtualBox文件夹

> 一般在C:\Users\用户名\.VirtualBox