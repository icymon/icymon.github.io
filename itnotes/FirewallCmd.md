### 防火墙伪装操作
* 检查是否允许伪装IP

``` shell
sudo firewall-cmd --query-masquerade
```

* 开启后端口转发才会生效

``` shell
sudo firewall-cmd --add-masquerade --permanent
```
* 禁止防火墙伪装IP

``` shell
sudo firewall-cmd --remove-masquerade
```

### 增加和移除端口转发规则

``` shell
sudo firewall-cmd --add-forward-port=port=8080:proto=tcp:toaddr=1.2.3.4:toport=1234 --permanent
sudo firewall-cmd --remove-forward-port=port=8080:proto=tcp:toaddr=1.2.3.4:toport=1234 --permanent
```

### 开放和移除端口

``` shell
sudo firewall-cmd --zone=public --add-port=5672/tcp --permanent
sudo firewall-cmd --remove-port=8081/tcp --permanent
```

### 重载防火墙

``` shell
sudo firewall-cmd --reload
```

### 查询防火墙状态

``` shell
sudo firewall-cmd --list-services
sudo firewall-cmd --list-forward-ports
sudo firewall-cmd --list-ports
```
