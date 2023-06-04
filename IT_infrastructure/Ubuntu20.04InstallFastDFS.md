# Ubuntu20.04安装fastdfs
## 安装编译环境
``` shell
sudo apt install build-essential
apt install -y gcc automake autoconf libtool make
```
## centos 安装编译环境
``` shell
# 后面安装nginx也会用到
yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl-devel libevent make automake autoconf libtool wget vim git -y
```
## 下载源码包

* 总共如下几个包
fastdfs-6.9.4.tar.gz  fastdfs-nginx-module-1.23.tar.gz  libfastcommon-1.0.66.tar.gz  libserverframe-1.1.25.tar.gz  nginx-1.24.0.tar.gz

* [fastdfs系列包](https://github.com/happyfish100)

* [Nginx下载页面](https://nginx.org/en/download.html)

## 编译安装
### 解压源码包
``` shell
tar -zxvf libfastcommon-1.0.66.tar.gz
tar -zxvf fastdfs-6.9.4.tar.gz
tar -zxvf fastdfs-nginx-module-1.23.tar.gz
tar -zxvf nginx-1.24.0.tar.gz
tar -zxvf libserverframe-1.1.25.tar.gz
```
### 安装libfastcommon
``` shell
cd libfastcommon-1.0.66/
sudo ./make.sh
sudo ./make.sh install
```
### 安装libserverframe
``` shell
cd libserverframe-1.1.25/
sudo ./make.sh
sudo ./make.sh install
```
### 安装fastdfs
``` shell
cd fastdfs-6.9.4/
sudo ./make.sh
sudo ./make.sh install
```
### 配置并启动Tracker、Storage服务

#### 创建目录
``` shell
$ mkdir /home/jingtai/fdfs/tracker -p
$ mkdir /home/jingtai/fdfs/storage -p
$ mkdir /home/jingtai/fdfs/client -p
```

#### 配置并启动Tracker服务
``` shell
vi tracker.conf
# 修改base_path属性，自定义tracker的数据和日志的输出目录
base_path=/home/jingtai/fdfs/tracker
# 保存并退出
:wq
# 配置防火墙，开放Tracker服务占用的22122端口
ufw enable 22l22
# 启动Tracker服务
fdfs_trackerd /etc/fdfs/tracker.conf start
```
#### 配置并启动Storage服务
``` shell
# 修改storage.conf文件
vi storage.conf
# 修改base_path属性，自定义tracker的数据和日志的输出目录
base_path=/home/jingtai/fdfs/storage
# 修改store_path属性，如果不配置就是跟base_path一样，我这里就直接跟配置base_path一样的路径了
store_path0=/home/jingtai/fdfs/storage
# 修改tracker_server地址，tracker服务所在的服务器的IP地址，有域名的也可以改成 域名:22122，如果有多个tracker服务，可以配置多行，官方默认给我配了两行，如果只有一个tracker服务，可以注释掉一行。
tracker_server = 10.0.2.191:22122
# 保存并退出
:wq
# 配置防火墙，开放Storage服务占用的23000端口
ufw enable 23000
# 启动Storage服务
fdfs_storaged /etc/fdfs/storage.conf start

```
#### 配置client
``` shell
# 修改client.conf文件
vim client.conf
# 修改base_path属性，自定义client的数据和日志的输出目录
base_path=/home/jingtai/fdfs/client
# 修改tracker_server地址，tracker服务所在的服务器的IP地址，有域名的也可以改成 域名:22122，如果有多个tracker服务，可以配置多行，官方默认给我配了两行，如果只有一个tracker服务，可以注释掉一行。
tracker_server = 10.0.2.191:22122
# 保存并退出
:wq
```


#### 测试上传文件
* 启动命令
``` shell
fdfs_trackerd /etc/fdfs/tracker.conf start
fdfs_storaged /etc/fdfs/storage.conf start
```

* 第一个命令：
``` shell
fdfs_test /etc/fdfs/client.conf upload abc.jpg
```

* 第二个命令：
``` shell
fdfs_upload_file /etc/fdfs/client.conf abc.jpg
```

## 整合nginx
### 复制和修改配置文件

#### 复制并修改fastdfs-nginx-module文件
``` shell
sudo cp /home/jingtai/fastdfs_zips/fastdfs-nginx-module-1.23/src/mod_fastdfs.conf /etc/fdfs/
sudo vi /etc/fdfs/mod_fastdfs.conf
tracker_server=10.0.2.191:22122
url_have_group_name = true
store_path0=/home/jingtai/fdfs/storage
```
#### 复制fastdfs配置文件

* 必要，否则可能会404

``` shell
cp /home/jingtai/fastdfs_zips/fastdfs-6.9.4/conf/http.conf /etc/fdfs/
cp /home/jingtai/fastdfs_zips/fastdfs-6.9.4/conf/mime.types /etc/fdfs/
```
### 安装Nginx

#### 安装编译工具

> centos环境：yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl-devel

``` shell
sudo apt-get install libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev 
```

#### 编译安装

``` shell
# 切换至 nginx 的解压目录
cd /usr/local/src/nginx-1.18.0
# 创建 nginx 的安装目录
mkdir -p /home/jingtai/nginx
# 添加 fastdfs-nginx-module 模块，指定 nginx 的安装路径
sudo ./configure --add-module=/home/jingtai/fastdfs_zips/fastdfs-nginx-module-1.23/src --prefix=/home/jingtai/nginx
# 编译并安装
sudo make && make install
```
#### 配置Nginx

* vim /home/jingtai/nginx/conf/nginx.conf 编辑配置文件，在 80 端口下添加以下内容。关于 Nginx 启动用户的问题请根据自身实际环境进行配置。
``` shell
location ~/group[0-9]/ {
    ngx_fastdfs_module;
}
```
#### 测试Nginx与FastDFS整合

启动 Nginx，命令为：/home/jingtai/nginx/sbin/nginx

此时客户端上传图片以后得到文件名为：group1/M00/00/00/wKgKZl9tkTCAJAanAADhaCZ_RF0495.jpg
浏览器访问：http://10.0.2.191/group1/M00/00/00/wKgKZl9tkTCAJAanAADhaCZ_RF0495.jpg

### 多节点配置（参考）

[参考](Ubuntu20.04InstallFastDFS_MultiNode.md)

### 异常处理关键字参考（按照上述版本步骤不会出现如下异常）
``` shell
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
```

### 非80端口nginx访问404问题（这里是个大坑，想破头）
在nginx中增加
```
user root root;
```
* 还有可能是存储路径不一致，需要检查下配置文件里的路径；另外可通过/var/log/nginx/error.log查看访问时404出错的路径是否存在该文件。
* 这里牵扯到另外一个细节，tracker、storage、client、nginx等配置文件中的端口需要保持一致，tracker、storage、client中配置项为http.server_port