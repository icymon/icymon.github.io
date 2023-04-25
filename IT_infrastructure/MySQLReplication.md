# MySQL主从复制（Replication）

```
环境：
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
# 获取默认root密码
grep 'temporary password' /var/log/mysqld.log
mysql -uroot -p
> SET PASSWORD = PASSWORD('Admin123!');
> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Admin123!' WITH GRANT OPTION;
> flush privileges;
```


## 配置主从
## 测试同步
## 恢复测验

---

``` sql
create database brian character set utf8 collate utf8_general_ci;
```

### 参考
* [centOS7安装MySQL教程 ](https://www.cnblogs.com/werr370/p/14633785.html)
* [mysql 5.7主从配置](https://www.cnblogs.com/miaocbin/p/13889783.html)
* [MySQL主从](https://www.cnblogs.com/Dominic-Ji/articles/15429590.html)
* [mysql数据库主从配置](https://www.cnblogs.com/atcloud/p/10773855.html)
* [MySQL主从及主主环境部署 ](https://www.cnblogs.com/brianzhu/p/10154446.html)
* [mysql主从恢复实战](https://www.cnblogs.com/wangke2017/p/15038367.html)
