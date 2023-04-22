## FastDFS多节点安装

> 参考：https://zhuanlan.zhihu.com/p/80256918?utm_id=0

[单节点部署及整合Nginx](Ubuntu20.04InstallFastDFS.md)

第一步 规定storage与tracker服务器

这里我用的是虚拟机，我这里在四台虚拟机上面都安装了单节点的fastdfs。我的四台虚拟机的ip如下。

192.168.223.15
192.168.223.16
192.168.223.17
192.168.223.18
192.168.223.15 所属组：group1 角色：storage，tracker1

192.168.223.16 所属组：group1 角色：storage

192.168.223.17 所属组：group2 角色：storage，tracker2

192.168.223.18 所属组：group2 角色：storage

第二步 修改配置文件

由于FastDFS单节点使用的组都是group1.所以192.168.223.15这台机器上的配置不需要做任意修改。所以我们需要修改的地方其实是其他三台服务器。下面我会逐个说明如何改。

首先我们需要改的是192.168.223.16。由上面的分配我们可以知道。他们都是group1，所以我们只需要把tracker的ip指向192.168.223.15 详细的修改如下。首先我们需要进入到192.168.223.16的/etc/fdfs的目录下面。这一步我们做了很多遍。这里就不演示了。接下来进行文件的修改

修改client.conf 第14行

tracker_server=192.168.223.15:22122
修改 storage.conf 第119行

tracker_server=192.168.223.15:22122
修改 mod_fastdfs.conf 第40行

tracker_server=192.168.223.15:22122
接下修改的 192.168.223.17这个服务器。由上面的分配来看，它的归属组是group2。它的tracker是192.168.223.17。现在我们开始修改

修改client.conf 第14行

tracker_server=192.168.223.17:22122
修改 storage.conf 第11行

group_name=group2
修改第 119行

tracker_server=192.168.223.17:22122
修改 mod_fastdfs.conf 第40行

tracker_server=192.168.223.17:22122
修改第 47行

group_name=group2
ip为192.168.223.18 像 192.168.223.17一样修改。这样我们就完成了所有配置文件的修改

第三步 关闭，重启服务

首先我们关闭所有服务器的storage服务，tracker服务。首先查找进程然后关闭

ps -ef | grep fdfs

root后面的字段就是pid。由上面可以知道。我们的两个pid是53946,53967,现在我们把这两个进程kill掉

kill -9 53946
kill -9 53967
其他三台服务器也是这样做。

现在按照单节的方式启动。记住不是所有的服务器都要启动。storage与tracker。

192.168.223.15 启动storage与tracker

192.168.223.16 启动storage

192.168.223.17 启动storage与tracker

192.168.223.18 启动storage

重启nginx服务，启动方式，先进入到nginx安装目录下的sbin目录，执行重启命令

./nginx -s reload
第四步 测试

我们在192.168.223.16 上传一张图片，然后用192.168.223.15的ip访问。因为同一个组的storage会进行文件同步


这里可以看到上传后得到的url是192.168.223.15服务器上面的。我们用ip 192.168.223.16 与 192.168.223.15 都访问一遍