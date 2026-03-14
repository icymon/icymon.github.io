# Debian 13 初始化配置
## 1、配置触摸板右击失效问题
* 参考 [(救命)Kali Linux或者其他linux系统的触控板右键按下没反应，失效的解决办法](https://blog.csdn.net/2202_75762088/article/details/138037918)

``` shell
gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
```
## 2、安装多媒体播放器

``` shell

sudo apt install vlc

```

## 3、配置清华源
[debian 清华源](https://mirrors.tuna.tsinghua.edu.cn/help/debian/)

``` shell
# /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

```



## 4、安装谷歌浏览器

``` shell
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```
## 5、卸载libreoffice
``` shell
sudo apt-get remove --purge libreoffice* && sudo apt-get autoremove
```
## 6、卸载snapd及火狐
``` shell
sudo apt autoremove --purge snapd
sudo apt remove firefox
```
## 7、安装火狐
``` shell
https://support.mozilla.org/zh-CN/kb/linux-firefox
```
## 8、安装sshd
``` shell
sudo apt-get install ssh
```

## 9、安装字体
将Windows/fonts下的字体，复制到/usr/share/fonts/my_fonts下面
执行如下命令，最后刷新字体
``` shell
sudo cp ~/Downloads/my.zip /usr/share/fonts/my_fonts/

sudo unzip my.zip 

sudo mkfontscale

sudo mkfontdir

sudo fc-cache
```
## 10、[GRUB美化](https://www.gnome-look.org/p/1307852)
[Tela grub theme](https://github.com/vinceliuice/grub2-themes)
[Sleek GrubBootloader themes](https://github.com/sandesh236/sleek--themes)

## 11、安装显卡驱动

* 安装nvidia驱动

``` shell
# 安装内核头文件和构建工具
sudo apt install -y linux-headers-$(uname -r) build-essential dkms
$ sudo dkms status # 新电脑应该无输出
$ sudo lspci -k | grep -A 2 -i "VGA\|3D"
pcilib: Error reading /sys/bus/pci/devices/0000:00:08.3/label: Operation not permitted
01:00.0 VGA compatible controller: NVIDIA Corporation AD107M [GeForce RTX 4050 Max-Q / Mobile] (rev a1)
	Subsystem: AIstone Global Limited Device 1278
	Kernel driver in use: nouveau
--
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt [Radeon 680M] (rev 0a)
	Subsystem: AIstone Global Limited Device 1278
	Kernel driver in use: amdgpu
# 这表示系统当前正在使用开源的nouveau驱动。在安装专有驱动前，我们不需要手动禁用nouveau——Debian的NVIDIA驱动包会自动处理这个问题。
$ sudo apt search nvidia-driver # 查找驱动
$ sudo apt install -y nvidia-driver nvidia-smi nvidia-settings
```

* 关闭原有显卡驱动

``` shell
vi /etc/modprobe.d/blacklist-nouveau.conf
```

* 在文件中添加：

``` shell
blacklist nouveau
options nouveau modeset=0
```

``` shell
sudo update-initramfs -u
```

## 12、GNOME Shell Extensions

* 先安装firefox浏览器扩展

[GNOME Shell integration](https://addons.mozilla.org/zh-CN/firefox/addon/gnome-shell-integration/)

* [Lock screen background](https://extensions.gnome.org/extension/1476/unlock-dialog-background/)

* [Bing Wallpaper](https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/)

## 13、截图工具 flameshot

``` shell
sudo apt-get install flameshot
sudo flameshot config  # 配置截图工具
flameshot gui   # 截图命令，可在系统快捷键中设置该命令，快速调用
```
## 14、禁用休眠

* 可在设置-电池管理中手动配置

``` shell
$ sudo systemctl status sleep.target 
[sudo]  的密码：
○ sleep.target - Sleep
     Loaded: loaded (/lib/systemd/system/sleep.target; static)
     Active: inactive (dead)
       Docs: man:systemd.special(7)
$ sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 
Created symlink /etc/systemd/system/sleep.target → /dev/null.
Created symlink /etc/systemd/system/suspend.target → /dev/null.
Created symlink /etc/systemd/system/hibernate.target → /dev/null.
Created symlink /etc/systemd/system/hybrid-sleep.target → /dev/null.
$ sudo systemctl status sleep.target 
○ sleep.target
     Loaded: masked (Reason: Unit sleep.target is masked.)
     Active: inactive (dead)
```

## 15、安装python库

``` shell
$ sudo apt install pip
$ sudo mv /usr/lib/python3.13/EXTERNALLY-MANAGED /usr/lib/python3.13/EXTERNALLY-MANAGED.bak
# 不要加sudo，安装在本用户下
$ pip install pymysql PyPDF2 numpy pandas xlrd matplotlib pillow wordcloud imageio jieba snownlp -i https://pypi.tuna.tsinghua.edu.cn/simple

```

## 16、安装VirtualBox
* AMD-V is being used by another hypervisor (VERR_SVM_IN_USE).

``` shell
sudo vi /etc/modprobe.d/blacklist.conf
blacklist kvm
blacklist kvm_amd

```

## 17、笔记本合上盖子由休眠改为锁屏

``` shell
$ sudo vi /etc/systemd/logind.conf

#HandleLidSwitch=suspend
HandleLidSwitch=lock
#HandleLidSwitchExternalPower=suspend
HandleLidSwitchExternalPower=lock
#HandleLidSwitchDocked=ignore
HandleLidSwitchDocked=lock

```

## 18、文件查找和删除、复制操作

``` shell

$ sudo find / -name *virtualbox* -exec rm -rf {} \;
$ sudo find /mydata -name *.iso -exec cp {} /home/ \;
```
## 19、安装阴历

``` shell
sudo apt-get install gir1.2-lunar*
```



