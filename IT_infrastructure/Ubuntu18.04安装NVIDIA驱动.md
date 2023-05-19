# Ubuntu18.04安装NVIDIA驱动

## 禁用nouveau

``` shell
sudo gedit /etc/modprobe.d/blacklist-nouveau.conf
# 添加两行语句
blacklist nouveau
options nouveau modeset=0
# 更新initramfs
sudo update-initramfs -u
sudo reboot 
lsmod | grep nouveau # 无输出则正常
```

## 关闭图形界面

``` shell
# 关闭用户图形界面，使用tty登录。
sudo systemctl set-default multi-user.target
# 开启用户图形界面。
sudo systemctl set-default graphical.target
# 重启后生效
sudo reboot
```

## 两种方式安装

### run file 方式安装
``` shell
$ sudo ./NVIDIA-XXXXXX.run -no-x-check -no-nouveau-check -no-opengl-files
# -no-x-check 安装驱动时不检查X服务，非必需。
# -no-nouveau-check 安装驱动时不检查nouveau，非必需。
# -no-opengl-files 表示只安装驱动文件，不安装OpenGL文件。这个参数不可省略，否则会导致登陆界面死循环，login loop or stuck in login。
# -Z, --disable-nouveau：禁用nouveau。此参数非必需，因为之前已经手动禁用了nouveau。
# 卸载驱动
$ sudo ./NVIDIA-XXXXXX.run -uninstall
```

### ppa方式安装

``` shell
$ sudo add-apt-repository ppa:graphics-drivers/ppa
$ sudo apt update
$ sudo ubuntu-drivers devices
# 列表中有recommend，autoinstall安装的就是这个版本，一般安装这个版本就行，如有特定要求，可以指定安装版本
$ sudo ubuntu-drivers autoinstall
# or
$ sudo ubuntu-drivers install nvidia-470
```

## 选择独显或者核显

``` shell
$ sudo apt install prime-select
$ sudo prime-select query
$ sudo prime-select intel
$ sudo prime-select nvidia
```

## 查看显卡状态和配置网卡

``` shell
# 查看网卡状态
$ sudo nvidia-smi
# 配置网卡
$ sudo nvidia-settings
```

## 其他注意事项

> 部分环境需要关闭BIOS里的UEFI的安全启动（disable）、关闭secure boot