## MySQL命令
### MySQL 备份和还原数据库
```
mysqldump -uroot -p -h 192.168.0.1 -P 123 --set-gtid-purged=OFF -x --hex-blob --default-character-set=utf8mb4 DBNAME > F:\DBNAME20201126.sql
# 导出并压缩
mysqldump -uroot -p -h 192.168.0.1 -P 123 --set-gtid-purged=OFF -x --hex-blob --default-character-set=utf8mb4 dbname table_name | gzip > /home/com.sql.gz

```
* -x 锁表
* --no-data 导出跳过的表结构 
* --ignore-table 跳过表和视图
* --tables 指定导出表

```
mysql -uroot -p -h 192.168.0.1 -P 123 --default-character-set=utf8mb4  DBNAME < F:\DBNAME202010291528.sql
```

``` sql
-- 查看数据目录
show  variables like 'datadir';
```
### Debian 11 安装 MySQL 8
#### deb包方式安装
* [Debian 11 安装 MySQL 8（deb包方式）](debian11mysql8.md)

### MySQL常见问题
#### gruop by报错this is incompatible with sql_mode=only_full_group_by 
* 参考[mysql命令gruop by报错this is incompatible with sql_mode=only_full_group_by](https://www.cnblogs.com/liyhbk/p/15649093.html)
* mysql5.7 以上默认开启了only_full_group_by选项。
* vim /etc/my.cnf 加入如下配置
``` shell
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
```
* 重启MySQL

#### Got an error reading communication packets

> mysql根据配置文件会限制server接受的数据包大小。有时候大的插入和更新会受max_allowed_packet参数限制，导致写入或者更新失败。

``` sql
mysql> show variables like 'max_allowed_packet';
+--------------------+---------+
| Variable_name      | Value   |
+--------------------+---------+
| max_allowed_packet | 4194304 |
+--------------------+---------+
1 row in set (0.00 sec)
```

``` shell
# vi /etc/my.cnf # 在[mysqld]加入200M：max_allowed_packet=20971520
# systemctl restart mysqld
# mysql -uroot -p
```

``` sql
mysql> show variables like 'max_allowed_packet';
+--------------------+----------+
| Variable_name      | Value    |
+--------------------+----------+
| max_allowed_packet | 20971520 |
+--------------------+----------+
1 row in set (0.01 sec)
```

> 临时修改：输入命令 set global max_allowed_packet = 2*1024*1024*10; 

### MySQL 优化
[MySQL 故障诊断：MySQL 占用 CPU 过高问题定位及优化](https://www.51cto.com/article/703691.html)