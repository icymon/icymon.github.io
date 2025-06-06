# Linux
## CentOS 安装 MySQL8.0
``` shell
# 卸载mariadb及自带的
#rpm -qa|grep mariadb
#rpm -qa|grep mysql
mariadb-libs-5.5.68-1.el7.x86_64
#sudo rpm -e --nodeps mariadb-libs-5.5.68-1.el7.x86_64
# 开始安装
#yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
#rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#yum install mysql-community-server
# grep "password" /var/log/mysqld.log
# mysql -uroot -p
>ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
>FLUSH PRIVILEGES;
>CREATE USER 'djh'@'10.0.2.2' IDENTIFIED WITH mysql_native_password BY '1111';
>GRANT ALL PRIVILEGES ON *.* TO 'djh'@'10.0.2.2';
>FLUSH PRIVILEGES;
# sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
# sudo firewall-cmd --reload
```

## CentOS 安装 MySQL5.7

### yum方式

``` shell
# 卸载mariadb及自带的
#rpm -qa|grep mariadb
#rpm -qa|grep mysql
mariadb-libs-5.5.68-1.el7.x86_64
#sudo rpm -e --nodeps mariadb-libs-5.5.68-1.el7.x86_64
# 开始安装
#wget http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
#yum -y install mysql57-community-release-el7-10.noarch.rpm
#rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#yum -y install mysql-community-server
# grep "password" /var/log/mysqld.log
# mysql -uroot -p
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '!Root123';
mysql> flush privileges;
# sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
# sudo firewall-cmd --reload
```

### rpm方式

``` shell
# 卸载mariadb及自带的
[hadoop@hadoop01 ~]$ rpm -qa|grep mariadb
[hadoop@hadoop01 ~]$ rpm -qa|grep mysql
mariadb-libs-5.5.68-1.el7.x86_64
[hadoop@hadoop01 ~]$ sudo rpm -e --nodeps mariadb-libs-5.5.68-1.el7.x86_64
# 下载及安装MySQL
[hadoop@hadoop01 ~]$ wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-5.7.36-1.el6.x86_64.rpm-bundle.tar
[hadoop@hadoop01 ~]$ tar -xvf mysql-5.7.36-1.el6.x86_64.rpm-bundle.tar
mysql-community-client-5.7.36-1.el6.x86_64.rpm
mysql-community-common-5.7.36-1.el6.x86_64.rpm
mysql-community-devel-5.7.36-1.el6.x86_64.rpm
mysql-community-embedded-5.7.36-1.el6.x86_64.rpm
mysql-community-embedded-devel-5.7.36-1.el6.x86_64.rpm
mysql-community-libs-5.7.36-1.el6.x86_64.rpm
mysql-community-libs-compat-5.7.36-1.el6.x86_64.rpm
mysql-community-server-5.7.36-1.el6.x86_64.rpm
mysql-community-test-5.7.36-1.el6.x86_64.rpm
[hadoop@hadoop01 ~]$ yum install libaio
[hadoop@hadoop01 ~]$ sudo rpm -ivh mysql-community-common-5.7.36-1.el6.x86_64.rpm
[hadoop@hadoop01 ~]$  sudo rpm -ivh mysql-community-libs-5.7.36-1.el6.x86_64.rpm
[hadoop@hadoop01 ~]$ sudo rpm -ivh mysql-community-client-5.7.36-1.el6.x86_64.rpm
[hadoop@hadoop01 ~]$ sudo rpm -ivh mysql-community-devel-5.7.36-1.el6.x86_64.rpm
[hadoop@hadoop01 ~]$ sudo rpm -ivh mysql-community-server-5.7.36-1.el6.x86_64.rpm --force --nodeps
[hadoop@hadoop01 ~]$ sudo systemctl start mysqld
[hadoop@hadoop01 ~]$ systemctl status mysqld
# 查询临时密码
[hadoop@hadoop01 ~]$ sudo grep 'temporary password' /var/log/mysqld.log
[hadoop@hadoop01 ~]$ mysql -uroot -hlocalhost -p
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '!Root123';
mysql> flush privileges;
```


## Ubuntu 安装 MySQL5.7
``` shell
$ wget https://cdn.mysql.com/archives/mysql-5.7/mysql-server_5.7.27-1ubuntu19.04_amd64.deb-bundle.tar
$ sudo dpkg -i mysql-common_5.7.27-1ubuntu19.04_amd64.deb
$ sudo apt install libaio1
$ sudo dpkg -i mysql-community-client_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqlclient20_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqlclient-dev_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i libmysqld-dev_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i mysql-client_5.7.27-1ubuntu19.04_amd64.deb
$ sudo apt install libmecab2 # 配置root密码
$ sudo dpkg -i mysql-community-server_5.7.27-1ubuntu19.04_amd64.deb
$ sudo dpkg -i mysql-server_5.7.27-1ubuntu19.04_amd64.deb
$ systemctl status mysql
```


# 创建测试库，并插入数据

``` sql
create database mydb character set utf8 collate utf8_general_ci;
use mydb;
CREATE TABLE t1(
id int not null,
name char(20)
);
insert into t1 values(1,'Tom');
select * from t1;
```









# Windows安装MySQL5.6

## 1、下载解压MySQL至目录

### 1、1在系统变量里选择PATH，在其后面添加: mysql bin文件夹的路径 (如: D:\Program Files\mysql-5.6\bin )，注意是追加，不是覆盖。

### 1、2拷贝 mysql 目录中的my-default.ini，重命名为my.ini

修改：

```
basedir = .....
datadir = .....
port = .....
server_id = .....
```

## 2、以管理员身份运行cmd（一定要用管理员身份运行，不然权限不够），通过命令，进入mysql bin 目录

> 输入 `mysqld --initialize-insecure --user=mysql` 回车

> 输入 `mysqld install` 回车

* 到此 mysql 安装成功

## 3、启动 MySQL

> 输入 net start mysql 回车，启动mysql服务，start 启动，stop 停止


## 4、安装和卸载MySQL服务

``` sql
mysqld -install
mysqld --remove mysql   
```

## 5、设置root密码

* 依次通过以下命令修改root用户名密码：

### 5.6
``` sql
mysql>use mysql; 
mysql>update user set password=password('your password') where user='root'; 
mysql>flush privileges;
```

### 5.7

``` sql
mysql>use mysql; 
mysql>update user set authentication_string=password('your password') where user='root'; 
mysql>flush privileges;
```

### 8.0
``` sql
mysql>use mysql; 
mysql>ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your password'; 
mysql>flush privileges;
```