# Debian安装docker及常用命令

> dockerhub大部分失效

## 1、Debian安装docker

### 1.1、下载并安装docker

``` shell
$ sudo apt-get remove docker docker-engine docker.io containerd runcl # 卸载自带的
# 在终端中执行以下命令来更新Ubuntu软件包列表和已安装软件的版本
$ sudo apt update
$ sudo apt upgrade
$ sudo apt-get install lsb-release curl
$ sudo curl -sS https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg # curl -sSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
$ sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
$ sudo apt update
$ sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
$ sudo systemctl start docker # 启动 Docker
$ sudo systemctl enable docker # 设置开机启动
$ sudo systemctl restart docker # 重启 docker
```

### 1.2、设置用户组
``` shell
# 创建 docker 组
sudo groupadd docker
# 将当前用户加入 docker 组
sudo usermod -aG docker $USER
# 刷新docker成员
newgrp docker
```

### 1.3、卸载 Docker

``` shell
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
# 删除 Docker 目录
sudo rm -rf /var/lib/docker
```

### 1.4、安装 Docker Compose
因为我们已经安装了 docker-compose-plugin，所以 Docker 目前已经自带 docker compose 命令，基本上可以替代 docker-compose。
如果某些镜像或命令不兼容，则我们还可以单独安装 Docker Compose：
``` shell
docker compose version
# Docker官方最新版本：
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## 2、常用命令
``` shell

```
 

## 3、参考：
* [Debian 12 / Ubuntu 24.04 安装 Docker 以及 Docker Compose 教程](https://u.sb/debian-install-docker/)
* [Debian 安装 Docker ](https://www.cnblogs.com/Lenbrother/p/18673403)
* [ubuntu环境安装docker ](https://www.cnblogs.com/fylh/p/18668624)
* [清华源docker](https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/)
* [Docker的常用命令](https://www.cnblogs.com/junnan/p/18637232)