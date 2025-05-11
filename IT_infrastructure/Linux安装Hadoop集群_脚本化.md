# Linux安装Hadoop3.4集群（三台）

## 设定hadoop用户
``` shell
$ useradd -m hdp -s /bin/bash
$ passwd hdp
# 可为 hadoop 用户增加管理员权限，方便部署（可选）
$ sudo adduser hdp sudo
```

``` shell
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
wget wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
mkdir -p ~/soft
tar -zxvf jdk-8u202-linux-x64.tar.gz ~/soft/
tar -zxvf hadoop-3.4.0.tar.gz -C ~/soft/
mv ~/soft/hadoop-3.4.0 ~/soft/hadoop
echo "# java cfg
export JAVA_HOME=/home/hdp/soft/jdk1.8.0_202
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# hadoop cfg
export HADOOP_HOME=/home/hdp/soft/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$HADOOP_HOME/sbin:$PATH
export PATH=$HADOOP_HOME/bin:$PATH
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native" >> ~/.bash_profile
source ~/.bash_profile
mkdir -p $HADOOP_HOME/tmp
sed -i '$a export JAVA_HOME=/home/hdp/soft/jdk1.8.0_202' $HADOOP_CONF_DIR/hadoop-env.sh
sed -i '$a export JAVA_HOME=/home/hdp/soft/jdk1.8.0_202' $HADOOP_CONF_DIR/yarn-env.sh
echo "hadoop02
hadoop03" > $HADOOP_CONF_DIR/workers
echo "<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
         <name>hadoop.tmp.dir</name>
         <value>file:/home/hdp/hadoop/tmp</value>
         <description>A base for other temporary directories.</description>
     </property>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop01:9000</value>
    </property>
</configuration>" > $HADOOP_CONF_DIR/core-site.xml

echo "<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
	<property>         
         <name>dfs.namenode.name.dir</name>         
         <value>/home/hdp/hadoop/tmp/dfs/name</value>     
     </property>    
     <property>         
         <name>dfs.datanode.data.dir</name>         
         <value>/home/hdp/hadoop/tmp/dfs/data</value>
     </property>
	 <property>
		 <name>dfs.namenode.secondary.http-address</name>
		 <value>worker1:9868</value>
	 </property>
</configuration>" > $HADOOP_CONF_DIR/hdfs-site.xml

echo "<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
  <name>yarn.app.mapreduce.am.env</name>
  <value>HADOOP_MAPRED_HOME=/home/hdp/hadoop</value>
</property>
<property>
  <name>mapreduce.map.env</name>
  <value>HADOOP_MAPRED_HOME=/home/hdp/hadoop</value>
</property>
<property>
  <name>mapreduce.reduce.env</name>
  <value>HADOOP_MAPRED_HOME=/home/hdp/hadoop</value>
</property>
</configuration>
" > $HADOOP_CONF_DIR/mapred-site.xml
echo "<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop01</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>
" > $HADOOP_CONF_DIR/yarn-site.xml

```

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

## 在机器上开放端口或者关闭防火墙
``` shell
sudo firewall-cmd --zone=public --add-port=8000-10000/tcp --permanent
sudo firewall-cmd --reload
# ufw开放端口
# ufw allow 8000:10000/tcp
```
### 启动Hadoop
``` shell
# 启动Hadoop
[hdp@master hadoop]$ hdfs namenode -format # 在节点01上执行
[hdp@master hadoop]$ hdfs datanode -format # 可不执行
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

## Tips

192.168.1.202:9870  --访问hadoop集群前台页面

192.168.1.202:8088  --访问hadoop的所有应用页面

还可以通过各个节点jps命令查看启动的任务节点状态。

### 其他执行命令
``` shell
# 在主节点启动Zookeeper
zkServer.sh start

# 在每个节点启动JournalNode
hadoop-daemon.sh start journalnode

# 格式化NameNode并启动
hdfs namenode -format
hadoop-daemon.sh start namenode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
# 启动ZKFC
hdfs zkfc -formatZK
hadoop-daemon.sh start zkfc

mr-jobhistory-daemon.sh start historyserver
```







