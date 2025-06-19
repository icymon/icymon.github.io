# Linux安装Hadoop3.4集群（三台）

## 设定hadoop用户
``` shell
$ useradd -m hadoop -s /bin/bash
$ passwd hadoop
# 可为 hadoop 用户增加管理员权限，方便部署（可选）
$ sudo adduser hadoop sudo
# sudo usermod -aG sudo username # CentOS系
```

## 下载安装包

* [Hadoop历史版本](https://archive.apache.org/dist/hadoop/common/)

* [华为云jdk版本下载](https://mirrors.huaweicloud.com/java/jdk/)

``` shell
$ wget https://mirrors.aliyun.com/apache/hadoop/common/stable/hadoop-3.4.1.tar.gz
$ wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
```

### 解压
``` shell
# tar -zxvf jdk-8u202-linux-x64.tar.gz -C /usr/local/
# tar -zxvf hadoop-3.4.1.tar.gz  -C /usr/local/
# chown -R hadoop:hadoop /usr/local/hadoop
```

## 安装配置JDK

### 配置Java

> 在.bashrc中添加环境变量

``` shell
vi ~/.bashrc
# java environment configuration
export JAVA_HOME=/usr/local/jdk
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# hadoop environment configuration
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native
root@master:/usr/local/hadoop# source ~/.bashrc
$ java -version
$ hadoop version
``` 

## 配置三台机器基本环境

### 将此环境复制两个worker：worker1和worker2

> 修改主机名、IP、hosts文件中的指向

``` shell
[hadoop@master ~]$ vi /etc/hosts
192.168.1.202 master
192.168.1.203 worker1
192.168.1.204 worker2
```

### 配置三台主机之间的免密登录
``` shell
ssh-keygen -t rsa # 在三台机器上分别执行
scp ~/.ssh/id_rsa.pub /.ssh/worker1.pub # worker1上执行
scp ~/.ssh/id_rsa.pub /.ssh/worker2.pub # woker2 上执行
cat ~/.ssh/*.pub >> ~/.ssh/authorized_keys # 在master上执行
# 在master上执行，将authorized_keys发到worker1、worker2上
scp ~/.ssh/authorized_keys hadoop@worker1:~/.ssh/
scp ~/.ssh/authorized_keys hadoop@worker2:~/.ssh/
# 如果使CentOS，需要修改.ssh目录权限
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
# 测试免密登录
ssh hadoop@worker1
```

## 配置Hadoop集群

### 配置Hadoop
``` shell
[hadoop@master ~]$ cd /usr/local/hadoop/etc/hadoop/
[hadoop@master hadoop]$ vi hadoop-env.sh # sed -i '$a export JAVA_HOME=/usr/local/jdk' hadoop-env.sh
export JAVA_HOME=/usr/local/jdk # 添加变量
[hadoop@master hadoop]$ vi yarn-env.sh # sed -i '$a export JAVA_HOME=/usr/local/jdk' yarn-env.sh
export JAVA_HOME=/usr/local/jdk # 添加变量
[hadoop@master hadoop]$ vi workers
worker1
worker2
[hadoop@master tmp]$ mkdir -p /usr/local/hadoop/tmp
[hadoop@master hadoop]$ vi core-site.xml
```

添加如下内容

``` xml
<configuration>
	<property>
		<name>hadoop.tmp.dir</name>
		<value>file:/usr/local/hadoop/tmp</value>
		<description>A base for other temporary directories.</description>
	</property>
	<property>
		<name>fs.defaultFS</name>
		<value>hdfs://master:9000</value>
	</property>
	<!-- 配置HDFS网页登录使用的静态用户为hadoop，不配置网页端无法上传文件 -->
	<property>
		<name>hadoop.http.staticuser.user</name>
		<value>hadoop</value>
	</property>
</configuration>
```

``` shell
[hadoop@master hadoop]$ vi hdfs-site.xml
```

添加如下内容

``` xml
<configuration>
	<property>
		<name>dfs.replication</name>
		<!--对于Hadoop的分布式文件系统HDFS而言，一般都是采用冗余存储，冗余因子通常为3，也就是说，一份数据保存三份副本。所以 ，dfs.replication的值还是设置为 2-->
		<value>2</value>
	</property>
	<property>
		<name>dfs.namenode.name.dir</name>
		<value>/usr/local/hadoop/tmp/dfs/name</value>
	</property>
	<property>
		<name>dfs.datanode.data.dir</name>
		<value>/usr/local/hadoop/tmp/dfs/data</value>
	</property>
	<!-- 2nn web端访问地址，一般放在另外一台从机上-->
	<property>
		<name>dfs.namenode.secondary.http-address</name>
		<value>worker1:9868</value>
	</property>
	<!-- 一般以上配置即可，其他默认 -->
	<!-- nn web端访问地址-->
	<property>
		<name>dfs.namenode.http-address</name>
		<value>master:9870</value>
	</property>
	<property>
		<name>dfs.http.address</name>
		<value>master:9870</value>
	</property>
	<!-- 如下3项如不设置，会报错： java.net.BindException: Cannot assign requested address -->
	<!-- worker中要改主机名为worker的hostname -->
	<property>
		<name>dfs.datanode.address</name>
		<value>master:9866</value>
	</property>
	<property>
		<name>dfs.datanode.ipc.address</name>
		<value>master:9867</value>
	</property>
	<property>
		<name>dfs.datanode.http.address</name>
		<value>master:9864</value>
	</property>
</configuration>
```

``` shell
[hadoop@master hadoop]$ vi mapred-site.xml
```

添加如下内容

``` xml
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
	<!-- 3.4以上版本必须如下配置 -->
	<property>
		<name>yarn.app.mapreduce.am.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
	<property>
		<name>mapreduce.map.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
	<property>
		<name>mapreduce.reduce.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
	<!-- 如果mapreduce任务报内存错误，需加入如下参数，具体数值视情况而定 -->
	<property>
		<name>mapreduce.map.memory.mb</name>
		<value>1024</value>
	</property>
	<property>
		<name>mapreduce.map.java.opts</name>
		<value>-Xmx512m</value>
	</property>
	<property>
		<name>mapreduce.reduce.memory.mb</name>
		<value>1024</value>
	</property>
	<property>
		<name>mapreduce.reduce.java.opts</name>
		<value>-Xmx512m</value>
	</property>
</configuration>
```

``` shell
[hadoop@master hadoop]$ vi yarn-site.xml
```

添加如下内容

``` xml
<configuration>
	<property>
		<name>yarn.resourcemanager.hostname</name>
		<value>master</value>
	</property>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>
	<!-- mapreduce任务内存不足时，视情况加入如下配置 -->
	<property>
		<name>yarn.nodemanager.vmem-pmem-ratio</name>
		<value>4</value>
	</property>
	<!-- 一般以上配置即可，其他默认 -->
	<property>
		<name>yarn.nodemanager.resource.memory-mb</name>
		<value>1024</value>
	</property>
	<property>
		<name>yarn.resourcemanager.address</name>
		<value>master:8032</value>
	</property>
	<property>
		<name>yarn.resourcemanager.scheduler.address</name>
		<value>master:8030</value>
	</property>
	<property>
		<name>yarn.resourcemanager.resource-master.address</name>
		<value>master:8035</value>
	</property>
	<property>
		<name>yarn.resourcemanager.admin.address</name>
		<value>master:8033</value>
	</property>
	<property>
		<name>yarn.resourcemanager.webapp.address</name>
		<value>master:8088</value>
	</property>
	<!-- 如下3项如不设置，会报错： java.net.BindException: Cannot assign requested address -->
	<!-- worker中要改主机名为worker的hostname -->
	<!-- localizer IPC -->
	<property>
		<name>yarn.nodemanager.localizer.address</name>
		<value>master:8040</value>
	</property>
	<!-- http服务端口 -->
	<property>
		<name>yarn.nodemanager.webapp.address</name>
		<value>master:8042</value>
	</property>
	<!-- NM中container manager的端口 -->
	<property>
		<name>yarn.nodemanager.address</name>
		<value>master:8041</value>
	</property>
</configuration>
```

* 添加Java环境

``` shell
sed -i '$a export JAVA_HOME=/usr/local/jdk' hadoop-env.sh
sed -i '$a export JAVA_HOME=/usr/local/jdk' yarn-env.sh
sed -i '$a export JAVA_HOME=/usr/local/jdk' mapred-env.sh
```

``` shell
# 将Hadoop配置文件复制到worker1和worker2机器上
[hadoop@master hadoop]$ scp -r /usr/local/hadoop/etc/hadoop/ hadoop@worker1:/usr/local/hadoop/etc/
[hadoop@master hadoop]$ scp -r /usr/local/hadoop/etc/hadoop/ hadoop@worker2:/usr/local/hadoop/etc/

# 在机器上开放端口
sudo firewall-cmd --zone=public --add-port=8000-10000/tcp --permanent
sudo firewall-cmd --reload
# ufw开放端口
# ufw allow 8000:10000/tcp
```
### 启动Hadoop
``` shell
# 启动Hadoop
[hadoop@master hadoop]$ hdfs namenode -format
[hadoop@master hadoop]$ hdfs datanode -format
# 启动Hadoop集群
[hadoop@master hadoop]$ start-all.sh
[hadoop@master ~]$ jps
18114 DataNode
19044 Jps
18666 NodeManager
18555 ResourceManager
17996 NameNode
18302 SecondaryNameNode
# 出现NameNode和SecondaryNameNode等5项证明配置没有问题。
```
## 配置zookeeper集群

* 解压并授权安装目录

``` shell
# vi ~/.bashrc
# zookeeper environment configuration
export ZK_HOME=/usr/local/zookeeper
export PATH=$PATH:$ZK_HOME/bin
# vi /usr/local/zookeeper/conf/zoo.cfg
dataDir=/usr/local/zookeeper/zkdata
server.1=hadoop01:2888:3888
server.2=hadoop02:2888:3888
server.3=hadoop03:2888:3888
# vi /usr/local/zookeeper/zkdata/myid
# 三台机器分别为1、2、3
# 启动zookeeper
zkServer.sh start
# 查看状态
zkServer.sh status
```

## 配置HBase集群
``` shell
# vi ~/.bashrc
# hbase environment configuration
export PATH=$PATH:/usr/local/hbase/bin
# * 解压并授权安装目录
$ sudo mv hbase-2.6.2 hbase
$ sudo chown -R hadoop hbase
$ mkdir -p /usr/local/hbase/conf/zookeeper
# hbase-env.sh
export JAVA_HOME=/usr/local/jdk
export HBASE_CLASSPATH=/usr/local/hbase/conf
export HBASE_MANAGES_ZK=false
export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=true
# hbase-site.xml
<property>
	<!-- Hbase Web UI 登录 -->
	<name>hbase.master.info.port</name>
	<value>60010</value>
</property>
<property>
	<name>hbase.tmp.dir</name>
	<value>/usr/local/hbase/tmp</value>
</property>
<property>
	<name>hbase.unsafe.stream.capability.enforce</name>
	<value>false</value>
</property>
<property>
	<!-- Hbase写入数据的目录 -->
	<name>hbase.rootdir</name>
	<value>hdfs://hadoop01:9000/hbase</value>
</property>
<property>
	<name>hbase.cluster.distributed</name>
	<value>true</value>
</property>
<property>
	<!-- list of zookeeper -->
	<name>hbase.zookeeper.quorum</name>
	<value>hadoop01,hadoop02,hadoop03</value>
</property>
<property>
	<!--zookooper配置、日志等的存储位置 -->
	<name>hbase.zookeeper.property.dataDir</name>
	<value>/usr/local/hbase/zookeeper</value>
</property>
# regionservers
hadoop01
hadoop02
hadoop03
```
## 配置Hive

``` shell
[hadoop@hadoop01 local]$ sudo mv apache-hive-3.1.3-bin hive
[hadoop@hadoop01 local]$ sudo chown -R hadoop hive
[hadoop@hadoop01 local]$ cd
[hadoop@hadoop01 ~]$ vi .bashrc
# hive environment configuration
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
export HIVE_CONF_DIR=/usr/local/hive/conf
[hadoop@hadoop01 ~]$ source .bashrc
[hadoop@hadoop01 ~]$ cd /usr/local/hive/conf
[hadoop@hadoop01 conf]$ cp hive-default.xml.template hive-default.xml
[hadoop@hadoop01 conf]$ cp hive-env.sh.template hive-env.sh
[hadoop@hadoop01 conf]$ vi hive-env.sh
export HADOOP_HOME=/usr/local/hadoop/
export HIVE_CONF_DIR=/usr/local/apache-hive-3.1.3-bin/conf
export HIVE_AUX_JARS_PATH=/usr/local/apache-hive-3.1.3-bin/lib
export HADOOP_HEAPSIZE=1024

[hadoop@hadoop01 conf]$ vi hive-site.xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>javax.jdo.option.ConnectionURL</name>
		<value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true&amp;useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8</value>
		<description>JDBC connect string for a JDBC metastore</description>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionDriverName</name>
		<value>com.mysql.jdbc.Driver</value>
		<description>Driver class name for a JDBC metastore</description>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionUserName</name>
		<value>hive</value>
		<description>username to use against metastore database</description>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionPassword</name>
		<value>hive</value>
		<description>password to use against metastore database</description>
	</property>
	<property>
		<name>hive.server2.enable.doAs</name>
		<value>false</value>
	</property>
</configuration>

[hadoop@hadoop01 ~]$ wget https://mirrors.aliyun.com/mysql/Connector-J/mysql-connector-java-5.1.48.tar.gz
[hadoop@hadoop01 mysql-connector-java-5.1.48]$ tar -zxvf mysql-connector-java-5.1.48.tar.gz
[hadoop@hadoop01 ~]$ cd mysql-connector-java-5.1.48/
[hadoop@hadoop01 mysql-connector-java-5.1.48]$ cp mysql-connector-java-5.1.48-bin.jar /usr/local/hive/lib/

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
mysql> CREATE USER 'hive'@'localhost' IDENTIFIED BY '!Hive123';
mysql> CREATE DATABASE IF NOT EXISTS hive DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
mysql> GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'localhost' identified by '!Hive123';
mysql> flush privileges;
# 初始化元数据
[hadoop@hadoop01 conf]$ schematool -dbType mysql -initSchema
...
Initialization script completed
schemaTool completed
# 启动hive
$hive
```



* 将/usr/local/hbase 同步到hadoop02、hadoop03两台虚拟机上，并做好授权。

``` shell
$start-all.sh # 主节点启动hadoop
$zkServer.sh start #每个节点都需要执行
$start-hbase.sh # 主节点启动hbase
# 以下是启动后每个节点的进程情况
[hadoop@hadoop01 local]$ jps
3008 HRegionServer
3172 Jps
2870 HMaster
2135 ResourceManager
1692 NameNode
2269 NodeManager
1806 DataNode
2686 QuorumPeerMain
[hadoop@hadoop02 local]$ jps
1636 HRegionServer
1365 NodeManager
1803 Jps
1260 SecondaryNameNode
[hadoop@hadoop03 local]$ jps
1155 DataNode
1492 HRegionServer
1399 QuorumPeerMain
1705 Jps
1259 NodeManager

```

## 问题记录

### SSH不能免密登录

如果还是需要密码登录，检查worker1上的/var/log/secure中的日志：
``` shell
worker1 sshd[1383]: Authentication refused: bad ownership or modes for file /home/hadoop/.ssh/authorized_keys
```

修改三台服务器上ssh文件的权限：
``` shell
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/*
```

### HIVE 报错：Exception in thread "main" java.lang.NoSuchMethodError: com.google.common.base.Preconditions.checkArgument

* 确保 Hive 中使用的 Guava 库版本与 Hadoop 中的版本一致。通常，版本不一致会导致 NoSuchMethodError。 

``` shell
[hadoop@hadoop01 conf]$ find $HADOOP_HOME -name "guava-*.jar"
/usr/local/hadoop/share/hadoop/yarn/csi/lib/guava-20.0.jar
/usr/local/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar
/usr/local/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar
[hadoop@hadoop01 conf]$ find $HIVE_HOME -name "guava-*.jar"
/usr/local/hive/lib/guava-19.0.jar
[hadoop@hadoop01 conf]$ mkdir /usr/local/hive/lib/bak
[hadoop@hadoop01 conf]$ mv /usr/local/hive/lib/guava-19.0.jar /usr/local/hive/lib/bak/
[hadoop@hadoop01 conf]$ cp /usr/local/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /usr/local/hive/lib/
```
### HBase建表时报错：ERROR: org.apache.hadoop.hbase.PleaseHoldException: Master is initializing

* 关闭hbase集群，并删除zookeeper下hbase节点，删除hdfs上/hbase目录，重新启动hbase集群。

### HBase建表时报错：NoNode for /hbase/master

参考：[HBase 提示：ERROR: KeeperErrorCode = NoNode for /hbase/master](https://www.cnblogs.com/xyzai/p/12695116.html)

* 1、检查Hadoop、zookeeper、hbase的运行情况；
* 2、list报错时，hbase-site.xml添加配置；
``` xml
<property>
<name>hbase.unsafe.stream.capability.enforce</name>
<value>false</value>
</property>
```
* 3、删除dfs上的hbase目录和zookeeper上的/hbase znode，重启hbase。

## Tips

192.168.1.202:9870  --访问hadoop集群前台页面

192.168.1.202:8088  --访问hadoop的所有应用页面

还可以通过各个节点jps命令查看启动的任务节点状态。

### hive 常见操作示例

``` sql
hive> show databases;
hive> create database if not exists test_hive;
hive> use test_hive;
hive> create table students(studentno int, studentname string) partitioned by (dept string) row format delimited fields terminated by '\t';
hive> DESC students;
hive> ALTER TABLE students ADD PARTITION (dept="Computer Science"); # 这里有个问题，插入中文名称的部门会报错，待解决。
hive> show partitions students;
OK
dept=Computer Science
Time taken: 0.155 seconds, Fetched: 1 row(s)
hive> INSERT OVERWRITE TABLE students PARTITION (dept='Computer Science') VALUES (1002, '贺思雅');
Query ID = hadoop_20250517010612_e2d82303-cc23-473f-b529-42f77e3e47a3
Total jobs = 3
Launching Job 1 out of 3
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1747412899650_0002, Tracking URL = http://hadoop01:8088/proxy/application_1747412899650_0002/
Kill Command = /usr/local/hadoop/bin/mapred job  -kill job_1747412899650_0002
Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
2025-05-17 01:06:23,592 Stage-1 map = 0%,  reduce = 0%
2025-05-17 01:06:30,804 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 1.73 sec
2025-05-17 01:06:38,002 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 3.41 sec
MapReduce Total cumulative CPU time: 3 seconds 410 msec
Ended Job = job_1747412899650_0002
Stage-4 is selected by condition resolver.
Stage-3 is filtered out by condition resolver.
Stage-5 is filtered out by condition resolver.
Moving data to directory hdfs://hadoop01:9000/user/hive/warehouse/test_hive.db/students/dept=Computer Science/.hive-staging_hive_2025-05-17_01-06-12_799_7613741112436369802-1/-ext-10000
Loading data to table test_hive.students partition (dept=Computer Science)
MapReduce Jobs Launched:
Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 3.41 sec   HDFS Read: 16296 HDFS Write: 297 SUCCESS
Total MapReduce CPU Time Spent: 3 seconds 410 msec
OK
Time taken: 27.435 seconds
hive> select * from students;
OK
1002    贺思雅  Computer Science
Time taken: 0.155 seconds, Fetched: 1 row(s)
```

### ubuntu安装MySQL5.7
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

## 参考
[Hadoop集群安装配置教程_Hadoop3.1.3_Ubuntu](https://dblab.xmu.edu.cn/blog/2775/)








