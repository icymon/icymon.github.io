# Linux安装Hadoop3.4集群（三台）

## 设定hadoop用户
``` shell
$ useradd -m hdp -s /bin/bash
$ passwd hdp
# 可为 hadoop 用户增加管理员权限，方便部署（可选）
$ sudo adduser hadoop sudo
```

## 下载安装包
``` shell
$ wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
$ wget wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
```

### 解压
``` shell
# tar -zxvf jdk-8u202-linux-x64.tar.gz -C /usr/local/
# tar -zxvf hadoop-3.4.0.tar.gz  -C /usr/local/
# chown -R hdp:hdp /usr/local/hadoop-3.4.0
```

## 安装配置JDK

### 配置Java

> 在.bashrc中添加环境变量

``` shell
vi /etc/profile
# java cfg
export JAVA_HOME=/usr/local/jdk1.8.0_202
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# hadoop cfg
export HADOOP_HOME=/usr/local/hadoop-3.4.0
export PATH=$HADOOP_HOME/sbin:$PATH
export PATH=$HADOOP_HOME/bin:$PATH
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native
root@Tracker:/usr/local/hadoop-3.4.0# source /etc/profile
hdp@Tracker:~$ java -version
java version "1.8.0_202"
Java(TM) SE Runtime Environment (build 1.8.0_202-b08)
Java HotSpot(TM) 64-Bit Server VM (build 25.202-b08, mixed mode)
hdp@Tracker:~$ hadoop version
Hadoop 3.4.0
Source code repository git@github.com:apache/hadoop.git -r bd8b77f398f626bb7791783192ee7a5dfaeec760
Compiled by root on 2024-03-04T06:35Z
Compiled on platform linux-x86_64
Compiled with protoc 3.21.12
From source with checksum f7fe694a3613358b38812ae9c31114e
This command was run using /usr/local/hadoop-3.4.0/share/hadoop/common/hadoop-common-3.4.0.jar
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

## 配置Hadoop集群

### 配置Hadoop
``` shell
[hdp@master ~]$ cd /usr/local/hadoop-3.4.0/etc/hadoop/
[hdp@master hadoop]$ vi hadoop-env.sh
export JAVA_HOME=/usr/local/jdk1.8.0_202 # 添加变量
[hdp@master hadoop]$ vi yarn-env.sh
export JAVA_HOME=/usr/local/jdk1.8.0_202 # 添加变量
[hdp@master hadoop]$ vi workers
worker1
worker2
[hdp@master tmp]$ mkdir -p /usr/local/hadoop-3.4.0/tmp
[hdp@master hadoop]$ vi core-site.xml
```

添加如下内容

``` xml
<configuration>
<property>
         <name>hadoop.tmp.dir</name>
         <value>file:/usr/local/hadoop-3.4.0/tmp</value>
         <description>A base for other temporary directories.</description>
     </property>
     <property>
         <name>fs.defaultFS</name>
         <value>hdfs://master:9000</value>
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
			<!--对于Hadoop的分布式文件系统HDFS而言，一般都是采用冗余存储，冗余因子通常为3，也就是说，一份数据保存三份副本。所以 ，dfs.replication的值还是设置为 2-->
         <value>2</value>     
     </property>     
     <property>         
         <name>dfs.namenode.name.dir</name>         
         <value>/usr/local/hadoop-3.4.0/tmp/dfs/name</value>     
     </property>    
     <property>         
         <name>dfs.datanode.data.dir</name>         
         <value>/usr/local/hadoop-3.4.0/tmp/dfs/data</value>
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
        <name>yarn.resourcemanager.hostname</name>
        <value>master</value>
     </property>
     <property>
         <name>yarn.nodemanager.aux-services</name>
         <value>mapreduce_shuffle</value>
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
[hdp@master hadoop]$ scp -r /usr/local/hadoop-3.4.0/etc/hadoop/ hdp@worker1:/usr/local/hadoop-3.4.0/etc/
[hdp@master hadoop]$ scp -r /usr/local/hadoop-3.4.0/etc/hadoop/ hdp@worker2:/usr/local/hadoop-3.4.0/etc/

# 在机器上开放端口
sudo firewall-cmd --zone=public --add-port=8000-10000/tcp --permanent
sudo firewall-cmd --reload
# ufw开放端口
# ufw allow 8000:10000/tcp
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

192.168.1.202:9870  --访问hadoop集群前台页面

192.168.1.202:8088  --访问hadoop的所有应用页面

还可以通过各个节点jps命令查看启动的任务节点状态。


## 参考
[Hadoop集群安装配置教程_Hadoop3.1.3_Ubuntu](https://dblab.xmu.edu.cn/blog/2775/)








