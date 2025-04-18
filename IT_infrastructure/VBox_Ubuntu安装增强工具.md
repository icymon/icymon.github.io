# 共享文件夹、粘贴板及拖放

## 1、挂载共享文件

``` shell
# 不安装显示不了挂载的文件夹
$sudo apt-get install virtualbox-guest-utils
# 如下选项可选
$sudo apt-get install libx11-dev libwayland-*
# 将共享文件夹挂载（share是主机文件夹的名字，share_dir是虚拟机文件夹的名称）
sudo mount -t vboxsf share share_dir
# 设置开机自动挂载
$sudo vi /etc/fstab
gongxiang /mnt/shared vboxsf defaults 0 0

```
## 2、安装增强工具

> 【共享粘贴板】选择“双向”；【拖放】选择“双向”。

``` shell
$ sudo apt-get install gcc make perl virtualbox-guest-additions-iso
$ sudo ps -elfH | grep VBoxClient
```

``` shell
$ sudo ./VBoxLinuxAdditions.run 

Verifying archive integrity...  100%   MD5 checksums are OK. All good.

Uncompressing VirtualBox 7.0.18 Guest Additions for Linux  100%  

VirtualBox Guest Additions installer

Removing installed version 7.0.18 of VirtualBox Guest Additions...

Copying additional installer modules ...

Installing additional modules ...

VirtualBox Guest Additions: Starting.

VirtualBox Guest Additions: Setting up modules

VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel 

modules.  This may take a while.

VirtualBox Guest Additions: To build modules for other installed kernels, run

VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup <version>

VirtualBox Guest Additions: or

VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup all

VirtualBox Guest Additions: Building the modules for kernel 6.8.0-57-generic.

update-initramfs: Generating /boot/initrd.img-6.8.0-57-generic

VirtualBox Guest Additions: Running kernel modules will not be replaced until 

the system is restarted or 'rcvboxadd reload' triggered

VirtualBox Guest Additions: reloading kernel modules and services

VirtualBox Guest Additions: kernel modules and services 7.0.18 r162988 reloaded

VirtualBox Guest Additions: NOTE: you may still consider to re-login if some 

user session specific services (Shared Clipboard, Drag and Drop, Seamless or 

Guest Screen Resize) were not restarted automatically


``` 

* 在【设置】-【显示】-【屏幕】-【扩展特性】，勾选“启用3D加速”，如不勾选，会报如下错误：

> DnD: Error: Leaving VM window failed (VERR_TIMEOUT).


## 参考
[]()