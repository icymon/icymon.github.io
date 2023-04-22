1、手动安装
``` shell
sudo apt-get autoremove open-vm-tools
sudo apt-get install open-vm-tools
sudo apt-get install open-vm-tools-desktop
```
2、不能拖拽文件
解决办法：
在菜单中点击虚拟机，然后点击安装（或者重新安装） VMWare Tools
如果是灰色的，先关闭虚拟机，然后在虚拟机设置分别设置CD/DVD、CD/DVD2和软盘为自动检测，再重启虚拟机，灰色字即点亮。

挂载后解压执行
``` shell
sudo ./vmware-install.pl
```