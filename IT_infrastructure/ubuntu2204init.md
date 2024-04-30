# 1、配置固定IP，设置端口映射
# 2、安装输入法
``` shell
sudo apt install fcitx-bin

sudo apt-get install fcitx-table -y
```
# 3、备份后，更换为清华源
``` shell
sudo cat /etc/apt/sources.list

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy -updates main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
```

# 4、安装谷歌浏览器
``` shell
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```
# 5、卸载libreoffice
``` shell
sudo apt-get remove --purge libreoffice* && sudo apt-get autoremove
```
# 6、卸载snapd及火狐
``` shell
sudo apt autoremove --purge snapd
sudo apt remove firefox
```
# 7、安装火狐
``` shell
https://support.mozilla.org/zh-CN/kb/linux-firefox
```
# 8、安装sshd
``` shell
sudo apt-get install ssh
```
# 9、安装字体
将Windows/fonts下的字体，复制到/usr/share/fonts/my_fonts下面
执行如下命令，最后刷新字体
``` shell
sudo cp ~/Downloads/my.zip /usr/share/fonts/my_fonts/

sudo unzip my.zip 

sudo mkfontscale

sudo mkfontdir

sudo fc-cache
```
# 10、[GRUB美化](https://www.gnome-look.org/p/1307852)
[Tela grub theme](https://github.com/vinceliuice/grub2-themes)
[Sleek GrubBootloader themes](https://github.com/sandesh236/sleek--themes)

# 11、安装显卡驱动
``` shell
apt install nvidia-driver
```
