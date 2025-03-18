## FastDFS多节点安装

> 参考：https://zhuanlan.zhihu.com/p/80256918?utm_id=0

[单节点部署及整合Nginx](Ubuntu20.04InstallFastDFS.md)

先启动tracker，再启动storage；

监控：

```
fdfs_monitor /etc/fdfs/client.conf list
```