# CentOSInstallJellyfin.md

``` shell
yum install dnf
wget https://mirrors.ustc.edu.cn/rpmfusion/free/el/rpmfusion-free-release-7.noarch.rpm
sudo dnf install rpmfusion-free-release-7.noarch.rpm
# https://repo.jellyfin.org/releases/server/centos/versions/stable/
sudo dnf install # link to version jellyfin server you want to install
sudo dnf install # link to web RPM you want to install
sudo systemctl start jellyfin
sudo systemctl enable jellyfin
sudo firewall-cmd --permanent --add-service=jellyfin
```
