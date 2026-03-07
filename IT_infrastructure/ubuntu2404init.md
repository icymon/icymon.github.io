# ubuntu 24.04 初始化配置
## 1、配置触摸板点击失效问题
* 参考 [ubuntu下触摸板点击无效的解决方案](https://www.cnblogs.com/kukudi/p/17345128.html)

``` shell
# 不一定是40开头
sudo vi /usr/share/X11/xorg.conf.d/40-libinput.conf
# 在Identifier "libinput touchpad catchall"中加上：
# 启用触摸板点击，就是轻敲触摸板是点击。
Option "Tapping" "on"
# 启用自然滚动，就是水果那个自然滚动。
Option "NaturalScrolling" "true"
# 左右键点击方式看手指而不是区域，单指左键双指右键，三指中键。
Option "ClickMethod" "clickfinger"
# 打字的时候禁用触摸板，算是变相防止误触。
Option "DisableWhileTyping" "True"
```
## 2、安装多媒体支持

``` shell

sudo apt install vlc ubuntu-restricted-extras
sudo apt install libpciaccess0 libtasn1-6

```

## 3、配置中科大源
[ubuntu 中科大源](https://mirrors.ustc.edu.cn/help/ubuntu.html)

``` shell

sudo cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
sudo cp ubuntu.sources /etc/apt/sources.list.d/

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

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
```

## 16、【检测到系统程序错误】弹框

``` shell
# 
$ sudo vi /etc/default/apport

# 将enabled由1改为0，关闭弹框提醒
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

## 20、安装python库

``` shell

$ sudo apt install python3-pkg-resources=68.1.2-2ubuntu1.2
$ sudo apt install python3-setuptools=68.1.2-2ubuntu1.2
$ sudo apt install python3-pip
$ sudo mv /usr/lib/python3.12/EXTERNALLY-MANAGED /usr/lib/python3.12/EXTERNALLY-MANAGED.bak
$ pip3 install pymysql PyPDF2 numpy pandas xlrd matplotlib pillow wordcloud imageio jieba snownlp -i https://pypi.tuna.tsinghua.edu.cn/simple

```
