# 域名解析暂时失败

> ping www.baidu.com 域名解析暂时失败,首次尝试编辑/etc/resolved.conf文件DNS为114.114.114.114，reboot后又恢复到127.0.0.53的内容

## 修改/etc/systemd/resolved.conf 
``` 
# vi /etc/systemd/resolved.conf 
# 在其中添加dns信息
DNS=114.114.114.114
# 保存退出

```

## 重启解析服务

``` 
systemctl restart systemd-resolved
``` 
## 设置解析服务开机启动

``` 
systemctl enable systemd-resolved
``` 

## 备份历史解析信息

``` 
mv /etc/resolv.conf /etc/resolv.conf.bak
```  

## 创建解析配置软链接 -f 表示如果链接存在则强制覆盖

``` 
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
``` 

## 查看/etc/resolv.conf 如果发现新的DNS 在里面了，说明成功了

``` 
cat /etc/resolv.conf
``` 