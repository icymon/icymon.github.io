# Qt安卓环境搭建
## 安装JDK
### 安装完成后设置环境变量（系统变量）
``` shell
JAVA_HOME C:\Program Files\Java\jdk1.8.0_271
CLASSPATH %JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;
Path ;C:\Program Files\Java\jdk1.8.0_271\bin（注意前面带;）

JAVA -version
```

## 安装SDK
### 1、installer_r24.4.1-windows.exe 双击安装，路径自己选择，安装完成后运行

* [installer_r24.4.1-windows](https://dl.google.com/android/installer_r24.4.1-windows.exe?utm_source=androiddevtools&utm_medium=website)

### 2、安装完成后设置环境变量（系统变量）
``` shell
ANDROID_SDK_HOME 
# 然后再在Path变量后添加以下两个路径（注意分号;）：
;%ANDROID_SDK_HOME%\tools
;%ANDROID_SDK_HOME%\platform-tools
```
SDK Manager.exe，根据你想要的安卓版本去安装所需要的相关工具包
如果打开没有显示可安装的工具则需要添加国内的软件源：
Tools–>option,在下面的两栏输入以下内容 网址： mirrors.neusoft.edu.cn 端口：80，点击close

然后点击Package–>Reload就会更新安卓的构建工具了

## NDK配置

* [NDK 下载](https://developer.android.google.cn/ndk/downloads?hl=zh-cn)

这个很简单，直接把下载的压缩包解压到你想放置的目录即可，在QT配置安卓设备的时候用到

## Qt安装配置
* 1、下一步直到完成安装
* 2、打开Qtcreator， 点击工具选项，JDK自己检测到了，只需要将SDK和NDK的路径添加进去，然后SDK manager会显示你下载的SDK工具，点击确定，环境就基本配置完成了








