## Linux下静默安装Oracle

* [Linux下静默安装Oracle](oracle/installoracle.md)

## 表空间管理
* 创建和删除表空间
``` sql
create tablespace oratbs datafile '/var/oracle/app/oradata/oratbs.dbf' size 30000M autoextend on next 50M maxsize unlimited;
create temporary tablespace oratbs_temp tempfile '/var/oracle/app/oradata/oratbs_temp.dbf' size 1000M autoextend on;
drop tablespace oratbs_temp including contents and datafiles cascade constraints ;
```
* 查看表空间大小
``` sql
SELECT t.tablespace_name, round(SUM(bytes / (1024 * 1024)), 0) ts_size 
FROM dba_tablespaces t, dba_data_files d 
WHERE t.tablespace_name = d.tablespace_name 
GROUP BY t.tablespace_name; 
```
* 查看默认表空间
``` sql
SELECT * FROM database_properties 
WHERE PROPERTY_NAME ='DEFAULT_PERMANENT_TABLESPACE'
```
* 修改默认表空间
``` sql
ALTER DATABASE DEFAULT TABLESPACE oratbs;
```

## 用户管理
* 创建用户
``` sql
create user username
identified by  11111
default tablespace 空间名
temporary tablespace TEMP
profile DEFAULT;
```
* 给用户授权限
``` sql
grant connect,resource,dba to username;
```
* 删除用户
``` sql
drop user username cascade;
```

## 数据泵操作
> 参考：https://www.cnblogs.com/chinas/p/8300955.html
### 逻辑目录管理
* 创建逻辑目录
``` sql
create directory auto_bankup as '/u01/app/oracle/bankup';
```
* 查看目录是否已经创建成功
``` sql
select * from dba_directories;
```
* 用sys管理员给指定用户赋予在该目录的操作权限
``` sql
grant read,write on directory auto_bankup to username;
```

### expdp导出
* 第一种：“full=y”，全量导出数据库:
``` sql
expdp user/passwd@orcl dumpfile=expdp.dmp directory=data_dir full=y logfile=expdp.log;
```
* 第二种：schemas按用户导出:
``` sql
expdp user/passwd@orcl schemas=user dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```
* 第三种：按表空间导出:
``` sql
expdp sys/passwd@orcl tablespace=tbs1,tbs2 dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```
* 第四种：导出表:
``` sql
expdp user/passwd@orcl tables=table1,table2 dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```
* 第五种：按查询条件导:
``` sql
expdp user/passwd@orcl tables=table1='where number=1234' dumpfile=expdp.dmp directory=data_dir logfile=expdp.log;
```

### impdp导入
> 注意：
>
>（1）确保数据库软件安装正确，字符集、数据库版本等与源库一致，尽量此类因素引起的失败。
>
>（2）确保数据库备份目录已提前建好，若没有，参考前面的说明建立该目录。
>
>（3）提前将源库导出的数据文件传递到目标库的备份目录下，并确保导入时的数据库用户对该文件有操作权限。


* 第一种：“full=y”，全量导入数据库；
``` sql
impdp user/passwd directory=data_dir dumpfile=expdp.dmp full=y;
```


* 第二种：同名用户导入，从用户A导入到用户A；
``` sql
impdp A/passwd schemas=A directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```
* 第三种：

* a.从A用户中把表table1和table2导入到B用户中；
``` sql
impdp B/passwdtables=A.table1,A.table2 remap_schema=A:B directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```

* b.将表空间TBS01、TBS02、TBS03导入到表空间A_TBS，将用户B的数据导入到A，并生成新的oid防止冲突；
``` sql
impdp A/passwdremap_tablespace=TBS01:A_TBS,TBS02:A_TBS,TBS03:A_TBS remap_schema=B:A FULL=Y transform=oid:n 
directory=data_dir dumpfile=expdp.dmp logfile=impdp.log
```

* 第四种：导入表空间；
``` sql
impdp sys/passwd tablespaces=tbs1 directory=data_dir dumpfile=expdp.dmp logfile=impdp.log;
```

* 第五种：追加数据；
``` sql
impdp sys/passwd directory=data_dir dumpfile=expdp.dmp schemas=system table_exists_action=replace logfile=impdp.log; 
```
> --table_exists_action:导入对象已存在时执行的操作。有效关键字:SKIP,APPEND,REPLACE和TRUNCATE

> 部分参数说明：
> * 数据泵导入语句 ：
> Impdp 用户名/密码  directory=目录名 dumpfile=xx.dmp remap_schema=导出时候的用户名：导入的时候用户名 remap_tablespace=参数 1：导入时创建的新表空间名,参数 2：导入时创建的新表空间名 logfile=日志.log
> 
> * 数据泵导出语句：
> expdp 用户名/密码 directory=目录名 dumpfile=xx.dmp schemas=用户名 logfile=日志.log

## 常用查询
### ORACLE SEQUENCE
* 创建ORACLE SEQUENCE

``` sql
CREATE SEQUENCE SEQ_TEST
MINVALUE 1
MAXVALUE 9999999999999999999999999999
START WITH 1
INCREMENT BY 1
NOCYCLE --达到最大值后不循环
CACHE 50 --缓存 提高性能
```

* 查询SEQUENCE

``` sql
SELECT SEQ_TEST.NEXTVAL FROM DUAL;
SELECT SEQ_TEST.CURRVALFROM DUAL; 
```

* 其他查询

``` sql
-- 增加字段
ALTER TABLE TEST2 ADD ADDRESS VARCHAR2(40);
ALTER TABLE TEST2 ADD NOTE VARCHAR2(40);

-- 查看表结构
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME='TEST2';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME='CLASSES';


-- 插入数据
INSERT INTO TEST2 VALUES(1,'301','4#4','CE');

-- 查询数据
SELECT * FROM TEST2;

--删除数据
DELETE FROM TEST2 WHERE ID=5;

-- 查询数据库的启动模式，在SYSDBA角色中使用
SELECT OPEN_MODE FROM V$DATABASE;

-- 查询控制文件
SELECT NAME FROM V$CONTROLFILE;

-- 查询SGA情况
SELECT NAME, BYTES FROM SYS.V_$SGASTAT ORDER BY NAME ASC

-- 查询有哪些数据库实例在运行
SELECT INST_NAME FROM V$ACTIVE_INSTANCES;

-- 查看连接数，修改连接数
SHOW PARAMETER PROCESSES;
ALTER SYSTEM SET PROCESSES=300 SCOPE=SPFILE;

-- 查询数据库当前进程的连接数：
SELECT COUNT(*) FROM V$PROCESS;

-- 查看数据库当前会话的连接数：
SELECT COUNT(*) FROM V$SESSION;

-- 查看数据库的并发连接数：
SELECT COUNT(*) FROM V$SESSION WHERE STATUS='ACTIVE';

-- 查看当前数据库建立的会话情况：
SELECT SID,SERIAL#,USERNAME,PROGRAM,MACHINE,STATUS FROM V$SESSION;

-- 查询数据库允许的最大连接数：
SELECT VALUE FROM V$PARAMETER WHERE NAME = 'PROCESSES';

-- 查看最近执行的SQL语句
SELECT * FROM V$SQL

-- 查看最近所作的操作
SELECT * FROM V$SQLAREA

--查询当前数据库的名称
SELECT NAME FROM V$DATABASE;

-- 查询当前实例名
SELECT INSTANCE_NAME FROM V$INSTANCE;

-- 创建用户并设置密码
ALTER USER TEST IDENTIFIED BY 123456;

-- 给用户授权
GRANT CREATE SESSION,CREATE TABLE,UNLIMITED TABLESPACE TO TEST;

-- 将表空间分配给用户
ALTER USER TEST DEFAULT TABLESPACE DATA_TEST;

-- 查询数据库信息
SELECT BANNER FROM SYS.V_$VERSION;

-- 查询表名注释
SELECT B.COMMENTS AS 注释 FROMUSER_TAB_COMMENTS B WHERE B.TABLE_NAME='TEST'

-- 查询全部数据表结构
SELECT*FROM USER_TAB_COLUMNS WHERE TABLE_NAME = UPPER('TEST');

-- 查询一个用户下的表
SELECT COUNT(*) FROM USER_TABLES;
SELECT COUNT(0) FROM DBA_OBJECTS WHERE OWNER = 'TEST' AND OBJECT_TYPE IN ('TABLE','VIEW') GROUP BY OBJECT_TYPE

-- 创建视图
CREATE VIEW V_ABC AS
SELECT * FROM ABC WHERE ROWNUM <100
SELECT * FROM V_ABC
-- 新建视图用户 VIEW_01 并赋予SELECT_CATALOG_ROLE角色 和 改视图的SELECT权限 ,在SYSTEM PRIVILEGE中需要CREATE SESSION权限用于登录
-- 登录 VIEW_01 用户 并查询U1用户的视图
SELECT * FROM U1.V_ABC

-- 查询主键
SELECT COL.COLUMN_NAME
FROM USER_CONSTRAINTS CON, USER_CONS_COLUMNS COL
WHERE CON.CONSTRAINT_NAME = COL.CONSTRAINT_NAME
AND CON.CONSTRAINT_TYPE = 'P'
AND COL.TABLE_NAME = 'TEST';--数据表名要大写

-- 查询表空间文件和表空间名。
SELECT FILE_NAME,TABLESPACE_NAME FROM DBA_DATA_FILES;

-- 三表关联查询
SELECT C.PPP, A.WDD, B.AWD
FROM TEST1 A
JOIN TEST2 B ON A.ID = B.ID
 AND ID = 1
JOIN TEST3 C ON B.CCC = C.CCC;
```