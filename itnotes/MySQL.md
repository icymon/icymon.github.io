## MySQL命令
### MySQL 备份和还原数据库
```
mysqldump -uroot -p -h 192.168.0.1 -P 123 --set-gtid-purged=OFF -x --hex-blob --default-character-set=utf8mb4 DBNAME > F:\DBNAME20201126.sql
```
* -x 锁表
* --no-data 导出跳过的表结构 
* --ignore-table 跳过表和视图
* --tables 指定导出表

```
mysql -uroot -p -h 192.168.0.1 -P 123 --default-character-set=utf8mb4  DBNAME < F:\DBNAME202010291528.sql
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
