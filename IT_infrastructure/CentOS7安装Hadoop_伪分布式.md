# Linux安装Hadoop+Spark

>  本机IP：192.168.1.190 (IP配置参考)

```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet static
	address 192.168.1.190/24
	network 192.168.1.0
	broadcast 192.168.1.255
	gateway 192.168.1.1
	dns-servers 8.8.8.8
	dns-servers 114.114.114.114
```


## 设定hadoop用户
``` shell
$ useradd -m hdp -s /bin/bash
$ passwd hdp
```

## 下载安装包
``` shell
$ wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
$ wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.3/hadoop-3.1.3.tar.gz
```

### 解压
``` shell
$ tar -zxvf jdk-8u202-linux-x64.tar.gz -C /usr/local/
$ tar -zxvf hadoop-3.1.3.tar.gz -C /usr/local/
```

## 安装配置JDK

### 配置Java

> 在/etc/profile中添加环境变量

``` shell
vi /etc/profile
# jdk configuration
export JAVA_HOME=/usr/local/jdk1.8.0_202
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

[hdp@master ~]$ source /etc/profile
[hdp@master ~]$ java -version
java version "1.8.0_341"
Java(TM) SE Runtime Environment (build 1.8.0_341-b10)
Java HotSpot(TM) 64-Bit Server VM (build 25.341-b10, mixed mode)
``` 



## 安装Hadoop

> 在/etc/profile中添加环境变量

``` shell
vi /etc/profile
export HADOOP_HOME=/usr/local/hadoop-3.1.3
export PATH=$HADOOP_HOME/sbin:$PATH
export PATH=$HADOOP_HOME/bin:$PATH
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib:$HADOOP_COMMON_LIB_NATIVE_DIR"

[hdp@master ~]$ vi /etc/profile
[hdp@master ~]$ source /etc/profile
[hdp@master ~]$ hadoop version
Hadoop 3.3.5
Source code repository https://github.com/apache/hadoop.git -r 706d88266abcee09ed78fbaa0ad5f74d818ab0e9
Compiled by stevel on 2023-03-15T15:56Z
Compiled with protoc 3.7.1
From source with checksum 6bbd9afcf4838a0eb12a5f189e9bd7
This command was run using /usr/local/hadoop-3.1.3/share/hadoop/common/hadoop-common-3.3.5.jar

``` 


## 配置免密登录

### 将此环境复制两个worker：worker1和worker2

> 修改主机名、IP、hosts文件中的指向

``` shell
[hdp@master ~]$ vi /etc/hosts
192.168.1.190 master
127.0.0.1 localhost
```

### 配置免密登录
``` shell
ssh localhost # 生成.ssh目录
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys # 在master上执行

# 测试免密登录
ssh localhost

```

## 配置Hadoop伪分布式

### 配置Hadoop
``` shell
[hdp@master ~]$ cd /usr/local/hadoop-3.1.3/etc/hadoop
[hdp@master hadoop]$ vi hadoop-env.sh
export JAVA_HOME=/usr/local/jdk1.8.0_202 # 添加变量
[hdp@master hadoop]$ vi yarn-env.sh
export JAVA_HOME=/usr/local/jdk1.8.0_202 # 添加变量
[hdp@master hadoop]$ vi workers
master
worker1
worker2
# 创建目录
$ mkdir -p /usr/local/hadoop-3.1.3/tmp
$ mkdir -p /usr/local/hadoop-3.1.3/tmp/dfs/name
$ mkdir -p /usr/local/hadoop-3.1.3/tmp/dfs/data
$ mkdir -p /usr/local/hadoop-3.1.3/tmp/dfs/namesecondary
$ chmod -R +777 /usr/local/hadoop-3.1.3/tmp
[hdp@master hadoop]$ vi core-site.xml
```

添加如下内容

``` xml
<configuration>
<property>
         <name>hadoop.tmp.dir</name>
         <value>file:/usr/local/hadoop-3.1.3/tmp</value>
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
         <value>/usr/local/hadoop-3.1.3/tmp/dfs/name</value>     
     </property>    
     <property>         
         <name>dfs.datanode.data.dir</name>         
         <value>/usr/local/hadoop-3.1.3/tmp/dfs/data</value>
     </property>
	 
	 <!-- 以下可不设置，为默认-->
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
# 以下可不设置，为默认
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
# 以下可不设置，为默认
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

192.168.1.190:9870  --访问hadoop集群前台页面

192.168.1.190:8088  --访问hadoop的所有应用页面

还可以通过各个节点jps命令查看启动的任务节点状态。











