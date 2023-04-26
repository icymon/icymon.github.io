# MySQL主从复制（Replication）
## 环境
```
CentOS7
MySQL5.7
主：192.168.1.180
从：192.168.1.181
```

## 安装MySQL
### yum 安装
``` shell
# MySQL8
# wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
# MySQL5.7
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm -ivh mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-server --nogpgcheck # yum安装的时候遇到公钥尚未安装的问题，添加--nogpgcheck
# 启动MySQL
systemctl start mysqld
systemctl status mysqld
# 获取默认root临时密码
grep 'temporary password' /var/log/mysqld.log
```

* 使用临时密码修改root密码，否则MySQL不允许进一步操作

``` sql
SET PASSWORD = PASSWORD('Admin123!');
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Admin123!' WITH GRANT OPTION;
flush privileges;
```

``` shell
# 防火墙放行端口
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
```
* 如果从服务器是主服务器克隆而来，则修改auto.cnf```vi /var/lib/mysql/auto.cnf```文件中```server-uuid```值，否则主从复制会报 1593 错误，修改完记得重启MySQL

## 配置主从
### 主库配置
``` shell
vi /etc/my.cnf
# 在[mysqld]下添加如下内容
# 主从复制配置-主库
#################################################################
# 服务的唯一编号
server-id = 1
# 开启mysql binlog功能
log-bin = mysql-bin
# binlog记录内容的方式，记录被操作的每一行
binlog_format = ROW
# 减少记录日志的内容，只记录受影响的列
binlog_row_image = minimal
# 指定需要复制的数据库名为jingtai
binlog-do-db = jingtai
# 配置不同步的库
binlog-ignore-db = mysql
binlog-ignore-db = sys
binlog-ignore-db = information_schema
binlog-ignore-db = performance_schema
#跳过从库错误
slave-skip-errors = all
#控制数据库的binlog刷到磁盘上去 , 0 不控制，性能最好，1每次事物提交都会刷到日志文件中，性能最差，最安全
sync_binlog = 1
#binlog过期清理时间
expire_logs_days = 7
#binlog每个日志文件大小
max_binlog_size = 100m
#binlog缓存大小
binlog_cache_size = 4m
#最大binlog缓存大小
max_binlog_cache_size= 512m
#################################################################

service mysqld restart

```

#### 创建数据库、用户

``` sql
-- 创建数据库、创建用户并授权
-- 数据库和表需要在从库上也创建一份一样的
create database jingtai character set utf8 collate utf8_general_ci;
CREATE USER 'jingtaim'@'%' IDENTIFIED BY 'Admin123!';
GRANT ALL privileges ON jingtai.* TO 'jingtaim'@'%' IDENTIFIED BY 'Admin123!';
-- 为从库复制创建用户，授权不能指定库：Since the REPLICATION SLAVE privileges are global and can not be assigned to a particular database, they must be specified globally in the query。
grant replication slave on *.* to 'jingtais'@'%' identified by 'Admin123!';
flush privileges;

mysql> show master status;
+------------------+----------+--------------+-------------------------------------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB                                | Executed_Gtid_Set |
+------------------+----------+--------------+-------------------------------------------------+-------------------+
| mysql-bin.000002 |     1642 | jingtai      | mysql,sys,information_schema,performance_schema |                   |
+------------------+----------+--------------+-------------------------------------------------+-------------------+
1 row in set (0.00 sec)
mysql> show master status\G -- 注意这一句没有分号
*************************** 1. row ***************************
             File: mysql-bin.000002
         Position: 1907
     Binlog_Do_DB: jingtai
 Binlog_Ignore_DB: mysql,sys,information_schema,performance_schema
Executed_Gtid_Set:
1 row in set (0.00 sec)


```

### 从库配置

``` shell
# 主从复制配置-从库
#################################################################
# 服务的唯一编号
server-id = 2
# 从库也可以开启binlog，但通常关闭
log-bin = mysql-bin
# binlog记录内容的方式，记录被操作的每一行
binlog_format = ROW
# 减少记录日志的内容，只记录受影响的列
binlog_row_image = minimal
# 指定需要复制的数据库名为jingtai
replicate-do-db = jingtai
# 配置不同步的库
binlog-ignore-db = mysql
binlog-ignore-db = sys
binlog-ignore-db = information_schema
binlog-ignore-db = performance_schema
#控制数据库的binlog刷到磁盘上去 , 0 不控制，性能最好，1每次事物提交都会刷到日志文件中，性能最差，最安全
sync_binlog = 1
#binlog过期清理时间
expire_logs_days = 7
#binlog每个日志文件大小
max_binlog_size = 100m
#binlog缓存大小
binlog_cache_size = 4m
#最大binlog缓存大小
max_binlog_cache_size= 512m
# 设置从库只读。此时若插入数据，报错：The MySQL server is running with the --read-only option so it cannot execute this statement
read_only = 1
#################################################################
```

service mysqld restart

``` sql
change master to master_host='192.168.1.180',master_user='jingtais',master_password='Admin123!',master_log_file='mysql-bin.000002',master_log_pos=3247;
start slave;
show slave status\G -- 注意这一句没有分号
```

---



## 测试同步

* 在主库添加数据，看从库是否同步到

* 测试发现：1、如果主库在主从同步pos前就有的一条记录被删后，从库同步报错；2、从库重新设置同步日志和pos后，不会将pos前的数据同步过去。

## 恢复测验



### 参考
* [centOS7安装MySQL教程 ](https://www.cnblogs.com/werr370/p/14633785.html)
* [mysql 5.7主从配置](https://www.cnblogs.com/miaocbin/p/13889783.html)
* [MySQL主从](https://www.cnblogs.com/Dominic-Ji/articles/15429590.html)
* [mysql数据库主从配置](https://www.cnblogs.com/atcloud/p/10773855.html)
* [MySQL主从及主主环境部署 ](https://www.cnblogs.com/brianzhu/p/10154446.html)
* [mysql主从恢复实战](https://www.cnblogs.com/wangke2017/p/15038367.html)
* [Solution of error “ERROR 1221 (HY000): Incorrect usage of DB GRANT and GLOBAL PRIVILEGES”](https://ixnfo.com/en/solution-of-error-error-1221-hy000-incorrect-usage-of-db-grant-and-global-privileges.html)
