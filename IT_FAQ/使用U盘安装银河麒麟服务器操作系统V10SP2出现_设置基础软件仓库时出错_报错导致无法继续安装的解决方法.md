# 使用U盘安装银河麒麟服务器操作系统V10SP2出现“设置基础软件仓库时出错”报错导致无法继续安装的解决方法

> 参考：https://blog.csdn.net/ShenSeKyun/article/details/127220974

* 推荐里面的方法2

方法②：修改安装引导启动参数

1、在安装引导界面，将光标移动到“Install Kylin Linux Advanced Server V10”选项，然后按下Tab键进入启动参数修改页面。

2、在启动参数末尾加上 inst.repo=hd:LABEL=xxxx，其中"xxxx"应与原有参数inst.stage2=hd:LABEL=后面的值一致，例如此处的KYLIN-SERVE。

3、确认修改正确后，按回车键进入系统安装界面，我们发现安装源还是报错“设置基础软件仓库时出错”，这是由于默认将/run/install/repo挂载为rw，需要切换到命令行模式重新挂载为ro，步骤如下：

（1）在图形化安装界面下同时按Ctrl+ALT+F2切换到命令行模式；

（2）执行命令 mount | grep repo 查看U盘挂载情况；

（3）执行命令 mount -o ro,remount /run/install/repo 重新挂载为ro；

（4）再按Ctrl+ALT+F6切回图形化安装界面，点击“安装源”进入软件源配置界面，然后点击左上角“完成”，这时我们发现已经能正常识别软件安装源了。
