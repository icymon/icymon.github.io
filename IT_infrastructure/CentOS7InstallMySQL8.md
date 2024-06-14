``` shell
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

# 使用ibd和frm恢复数据（缺失ibdata1，须有表结构）

## 1、备份初始化的数据库 库名和ibdata1

## 2、创建测试库，并插入数据

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

## 3、备份修改后的数据库 库名和ibdata1

## 4、使用1恢复数据库至初始化状态（关闭数据库覆盖文件，再启动）

## 5、创建库名和表结构，关闭数据库，并用3中的ibd和frm覆盖数据，启动数据库。

``` sql
alter table t1 discard tablespace;
ALTER TABLE t1 IMPORT TABLESPACE;
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