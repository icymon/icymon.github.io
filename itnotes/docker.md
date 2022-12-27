# Docker相关操作和配置

### 容器与宿主机时间不一致
``` shell
$ docker cp /usr/share/zoneinfo/Asia/Shanghai container_name:/etc/localtime
```
