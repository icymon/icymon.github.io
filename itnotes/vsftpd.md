### 安装vsftpd
``` shell
sudo apt-get install vsftpd
```

### 配置vsftpd 
配置文件路径
> /etc/vsftpd/vsftpd.conf

``` shell

# 禁止匿名访问
anonymous_enable=NO
# 允许本地用户登陆
local_enable=YES
# 是否禁止用户离开设置的根目录
chroot_list_enable=NO
chroot_local_user=YES
# 通过搭配能实现以下几种效果：
# ①当chroot_list_enable=YES，chroot_local_user=YES时，在/etc/vsftpd.chroot_list文件中列出的用户，可以切换到其他目录；未在文件中列出的用户，不能切换到其他目录。
# ②当chroot_list_enable=YES，chroot_local_user=NO时，在/etc/vsftpd.chroot_list文件中列出的用户，不能切换到其他目录；未在文件中列出的用户，可以切换到其他目录。
# ③当chroot_list_enable=NO，chroot_local_user=YES时，所有的用户均不能切换到其他目录。
# ④当chroot_list_enable=NO，chroot_local_user=NO时，所有的用户均可以切换到其他目录。


# 表示让家目录可写
allow_writeable_chroot=YES
# 全局设置，是否容许写入（无论是匿名用户还是本地用户，若要启用上传权限的话，就要开启它）
write_enable=YES
# umask是unix操作系统的概念，umask决定目录和文件被创建时得到的初始权限
# umask = 022 时，新建的目录 权限是755，文件的权限是 644
# umask = 077 时，新建的目录 权限是700，文件的权限是 600
local_umask=022

# 关闭PASV模式的安全检查
pasv_promiscuous=YES
# 开启被动模式
pasv_enable=YES
# 被动模式数据交换端口范围
pasv_min_port=10000
pasv_max_port=10000
# 使vsftpd在pasv命令回复时跳转到指定的IP地址。例如外网访问，提示返回了不可路由的服务器地址
pasv_address=192.168.0.123　　

# 允许为目录配置显示信息,显示每个目录下面的message_file文件的内容
dirmessage_enable=YES

# 开启日志功能
xferlog_enable=YES
# 如果启用该选项，系统将会维护记录服务器上传和下载情况的日志文件。
xferlog_std_format=YES
# 如果启用该选项，传输日志文件将以标准 xferlog 的格式书写，该格式的日志文件默认为 /var/log/xferlog，也可以通过 xferlog_file 选项对其进行设定。默认值为NO。
xferlog_file=/var/log/xferlog

# vsftpd的配置文件/etc/vsftpd.conf把中"listen=YES"和"listen_ipv6=YES"是不能同时开启。 
# 默认配置下"listen=YES"开启，"listen_ipv6=YES"被注释掉了，此时vsftpd只能监听到IPv4的FTP请求，不能监听到IPv6的FTP请求。
# 怎样让vsftpd同时支持IPv4和IPv6？经过测试发现只要把'/etc/vsftpd.conf'配置文件中listen=YES"注释掉，，"listen_ipv6=YES"开启，保存配置文件。
listen=NO
listen_ipv6=YES

# 设置PAM使用的名称，默认值为/etc/pam.d/vsftpd
pam_service_name=vsftpd

# vsftpd.user_list文件中的用户账号被禁止进行FTP登录；userlist _deny设置为NO表示vsftpd.usre_list文件用于设置只允许登录的用户账号，文件中未包括的用户账号被禁止FTP登录。
userlist_enable=YES
userlist_deny=YES

# 是否使用tcp_wrappers作为主机访问控制方式。
tcp_wrappers=YES

```

### 创建FTP用户，并配置密码 

``` shell
sudo useradd -d /home/sftpUser -s /sbin/nologin -g ftpUser ftpUser
sudo passwd ftpUser
```

### NAT被动模式

> 以filezilla server为例

* 1、设置被动端口范围、监听端口，同时防火墙开放上述端口；
* 2、配置public IP，路由器外的公网IP。注：虚拟机情况下，不能填虚拟机本机IP，须互联网公网IP。

### 测试

``` shell
curl ftp://host_ip:port -u name:passwd -o dir_path/file_name
```




