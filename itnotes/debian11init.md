# Debian 11初始化配置
## 1、卸载系统自带游戏
* 需要先将软件源更新（最好更换速度快的源）

``` shell
sudo apt update

sudo apt purge aisleriot gnome-sudoku mahjongg ace-of-penguins gnomine gbrainy gnome-sushi gnome-nibbles gnome-taquin gnome-tetravex  gnome-robots gnome-chess lightsoff swell-foop quadrapassel tali gnome-mahjongg gnome-2048 iagno gnome-klotski five-or-more gnome-mines four-in-a-row hitori && sudo apt autoremove
```
## 2、安装输入法

``` shell
sudo apt install fcitx-bin
sudo apt-get install fcitx-table -y
```

## 3、备份后，更换为清华源
[Debian 镜像使用帮助|清华源](https://mirrors.tuna.tsinghua.edu.cn/help/debian/)


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
sudo apt install nvidia-detect nvidia-driver linux-headers-$(uname -r)
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

## 15、sda、sdb重启变化

``` shell
# 查出设备uuid
$ ls -la /dev/disk/by-id
# 写入fstab
/dev/disk/by-id/xxxxxxxxxxxxxx-part1	/data	ext4	defaults	0	0
