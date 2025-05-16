# CentOS7安装Hadoop+Spark

## 设定hadoop用户
``` shell
$ useradd -m hdp -s /bin/bash
$ passwd hdp
```

## 下载安装包
``` shell
$ wget https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz
$ wget https://www.apache.org/dyn/closer.lua/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz
$ jdk-8u341-linux-x64.tar.gz
# wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
# 下载Scala包
$ wget https://github.com/lampepfl/dotty/releases/download/3.2.2/scala3-3.2.2.tar.gz
```

### 解压
``` shell
$ tar -zxvf jdk-8u341-linux-x64.tar.gz -C /home/hdp/
$ tar -zxvf hadoop-3.3.5.tar.gz -C /home/hdp/
$ tar -zxvf scala3-3.2.2.tar.gz -C /home/hdp/
$ tar -zxvf spark-3.4.0-bin-hadoop3.tgz -C /home/hdp/
```

## 安装配置JDK

### 配置Java

> 在.bashrc中添加环境变量

``` shell
vi .bashrc
export JAVA_HOME=/home/hdp/jdk1.8.0_341
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

[hdp@master ~]$ source .bashrc
[hdp@master ~]$ java -version
java version "1.8.0_341"
Java(TM) SE Runtime Environment (build 1.8.0_341-b10)
Java HotSpot(TM) 64-Bit Server VM (build 25.341-b10, mixed mode)
``` 


## 安装Scala

> 在.bashrc中添加环境变量

``` shell
vi .bashrc
export SCALA_HOME=/home/hdp/scala3-3.2.2
export PATH=$SCALA_HOME/bin:$PATH

[hdp@master ~]$ vi .bashrc
[hdp@master ~]$ source .bashrc
[hdp@master ~]$ scala -version
Scala code runner version 3.2.2 -- Copyright 2002-2023, LAMP/EPFL

``` 


## 安装Hadoop

> 在.bashrc中添加环境变量

``` shell
vi .bashrc
export HADOOP_HOME=/home/hdp/hadoop-3.3.5
export PATH=$HADOOP_HOME/sbin:$PATH
export PATH=$HADOOP_HOME/bin:$PATH
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native

[hdp@master ~]$ vi .bashrc
[hdp@master ~]$ source .bashrc
[hdp@master ~]$ hadoop version
Hadoop 3.3.5
Source code repository https://github.com/apache/hadoop.git -r 706d88266abcee09ed78fbaa0ad5f74d818ab0e9
Compiled by stevel on 2023-03-15T15:56Z
Compiled with protoc 3.7.1
From source with checksum 6bbd9afcf4838a0eb12a5f189e9bd7
This command was run using /home/hdp/hadoop-3.3.5/share/hadoop/common/hadoop-common-3.3.5.jar

``` 
## 安装Spark

``` shell
[hdp@master conf]$ cp /home/hdp/spark-3.4.0-bin-hadoop3/conf/spark-env.sh.template /home/hdp/spark-3.4.0-bin-hadoop3/conf/spark-env.sh
# spark conf
export SCALA_HOME=/home/hdp/scala3-3.2.2
export JAVA_HOME=/home/hdp/jdk1.8.0_341
export HADOOP_INSTALL=/home/hdp/hadoop-3.3.5
export HADOOP_CONF_DIR=$HADOOP_INSTALL$/etc/hadoop
SPARK_MASTER_IP=master
SPARK_LOCAL_DIRS=/home/hdp/spark-3.4.0-bin-hadoop3
SPART_DRIVER_MEMORY=1G
[hdp@master conf]$ cp /home/hdp/spark-3.4.0-bin-hadoop3/conf/workers.template /home/hdp/spark-3.4.0-bin-hadoop3/conf/workers
[hdp@master conf]$ vi /home/hdp/spark-3.4.0-bin-hadoop3/conf/workers
master
worker1
worker2
```
## 配置三台机器基本环境

### 将此环境复制两个worker：worker1和worker2

> 修改主机名、IP、hosts文件中的指向

``` shell
[hdp@master ~]$ vi /etc/hosts
192.168.1.202 master
192.168.1.203 worker1
192.168.1.204 worker2
```

### 配置三台主机之间的免密登录
``` shell
ssh-keygen -t rsa # 在三台机器上分别执行
scp ~/.ssh/id_rsa.pub hdp@master:~/.ssh/id_rsa.pub.worker1 # worker1上执行
scp ~/.ssh/id_rsa.pub hdp@master:~/.ssh/id_rsa.pub.worker2 # woker2 上执行
cat ~/.ssh/id_rsa.pub* >> ~/.ssh/authorized_keys # 在master上执行
# 在master上执行，将authorized_keys发到worker1、worker2上
scp ~/.ssh/authorized_keys hdp@worker1:~/.ssh/
scp ~/.ssh/authorized_keys hdp@worker2:~/.ssh/

# 测试免密登录
ssh hdp@worker1

```

## 配置Hadoop和Spark集群

### 配置Hadoop
``` shell
[hdp@master ~]$ cd /home/hdp/hadoop-3.3.5/etc/hadoop
[hdp@master hadoop]$ vi hadoop-env.sh
export JAVA_HOME=/home/hdp/jdk1.8.0_341 # 添加变量
[hdp@master hadoop]$ vi yarn-env.sh
export JAVA_HOME=/home/hdp/jdk1.8.0_341 # 添加变量
[hdp@master hadoop]$ vi workers
worker1
worker2
[hdp@master tmp]$ mkdir -p /home/hdp/hadoop-3.3.5/tmp
[hdp@master hadoop]$ vi core-site.xml
```

添加如下内容

``` xml
<configuration>
<property>
         <name>hadoop.tmp.dir</name>
         <value>file:/home/hdp/hadoop-3.3.5/tmp</value>
         <description>A base for other temporary directories.</description>
     </property>
     <property>
         <name>fs.defaultFS</name>
         <value>hdfs://master:20001</value>
     </property>
</configuration>
```

``` shell
[hdp@master hadoop]$ vi hdfs-site.xml
```

添加如下内容

``` xml
<configuration>	 
     <property>         
         <name>dfs.replication</name>         
         <value>2</value>     
     </property>     
     <property>         
         <name>dfs.namenode.name.dir</name>         
         <value>/home/hdp/hadoop-3.3.5/tmp/dfs/name</value>     
     </property>    
     <property>         
         <name>dfs.datanode.data.dir</name>         
         <value>/home/hdp/hadoop-3.3.5/tmp/dfs/data</value>
     </property>
	 <!-- nn web端访问地址-->
	 <property>
		 <name>dfs.namenode.http-address</name>
		 <value>master:9870</value>
	 </property>
	 <!-- 2nn web端访问地址-->
	 <property>
		 <name>dfs.namenode.secondary.http-address</name>
		 <value>master:9868</value>
	 </property>
	 <!-- -->
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
[hdp@master hadoop]$ vi mapred-site.xml
```

添加如下内容

``` xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```

``` shell
[hdp@master hadoop]$ vi yarn-site.xml
```

添加如下内容

``` xml
<configuration>
     <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>1024</value>
     </property>
	 <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>master</value>
     </property>
     <property>
         <name>yarn.nodemanager.aux-services</name>
         <value>mapreduce_shuffle</value>
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
         <name>yarn.resourcemanager.resource-tracker.address</name>         
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

``` shell
# 将Hadoop配置文件复制到worker1和worker2机器上
[hdp@master hadoop]$ scp -r /home/hdp/hadoop-3.3.5/etc/hadoop hdp@worker1:/home/hdp/hadoop-3.3.5/etc/
[hdp@master hadoop]$ scp -r /home/hdp/hadoop-3.3.5/etc/hadoop hdp@worker2:/home/hdp/hadoop-3.3.5/etc/

# 在机器上开放端口
sudo firewall-cmd --zone=public --add-port=20001-20007/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9870/tcp --permanent
sudo firewall-cmd --reload
```
### 启动Hadoop
``` shell
# 启动Hadoop
[hdp@master hadoop]$ hdfs namenode -format
[hdp@master hadoop]$ hdfs datanode -format
# 启动Hadoop集群
[hdp@master hadoop]$ start-all.sh
[hdp@master ~]$ jps
18114 DataNode
19044 Jps
18666 NodeManager
18555 ResourceManager
17996 NameNode
18302 SecondaryNameNode
# 出现NameNode和SecondaryNameNode等5项证明配置没有问题。
```
### 配置Spark

``` shell
[hdp@master ~]$ cd /home/hdp/spark-3.4.0-bin-hadoop3/conf
[hdp@master conf]$ vi spark-env.sh
export SCALA_HOME=/home/hdp/scala3-3.2.2
export JAVA_HOME=/home/hdp/jdk1.8.0_341
export HADOOP_INSTALL=/home/hdp/hadoop-3.3.5
export HADOOP_CONF_DIR=$HADOOP_INSTALL/etc/hadoop
SPARK_MASTER_IP=master
SPARK_LOCAL_DIRS=/home/hdp/spark-3.4.0-bin-hadoop3
SPART_DRIVER_MEMORY=512m
[hdp@master conf]$ vi workers
master
worker1
worker2
[hdp@master conf]$ scp -r /home/hdp/spark-3.4.0-bin-hadoop3/conf hdp@worker1:/home/hdp/spark-3.4.0-bin-hadoop3/
[hdp@master conf]$ scp -r /home/hdp/spark-3.4.0-bin-hadoop3/conf hdp@worker2:/home/hdp/spark-3.4.0-bin-hadoop3/

[hdp@master sbin]$ cd /home/hdp/spark-3.4.0-bin-hadoop3/sbin
[hdp@master sbin]$ ./start-all.sh

# 访问：master:8080，若显示3个worker则为成功。


```


## 问题记录

### SSH不能免密登录

如果还是需要密码登录，检查worker1上的/var/log/secure中的日志：
``` shell
worker1 sshd[1383]: Authentication refused: bad ownership or modes for file /home/hdp/.ssh/authorized_keys
```

修改三台服务器上ssh文件的权限：
``` shell
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/*
```


## Tips

192.168.1.202:9870  --访问hadoop集群前台页面

192.168.1.202:8088  --访问hadoop的所有应用页面

还可以通过各个节点jps命令查看启动的任务节点状态。











