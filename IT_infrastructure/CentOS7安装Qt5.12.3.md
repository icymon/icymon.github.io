# centos7安装Ot5.12.3

## 图形界面安装
wget https://download.qt.io/archive/qt/5.12/5.12.3/qt-opensource-linux-x64-5.12.3.run
yum groupinstall "GNOME Desktop"
sudo yum install wget mesa-libGL-devel -y
startx
systemctl get-default
systemctl set-default graphical.target
sudo wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sudo yum install -y xrdp
sudo yum install -y tigervnc-server
sudo vim /etc/xrdp/xrdp.ini #改端口
sudo systemctl start xrdp
sudo systemctl enable xrdp 
sudo systemctl restart xrdp
sudo firewall-cmd --permanent --zone=public --add-port=3389/tcp
# 安装linuxdeployqt
nuxdeployqt-continuous-x86_64.AppImage linuxdeployqt
chmod +x linuxdeployqt
mv linuxdeployqt /usr/local/bin/ 
# 增加PATH
vi /etc/profile
export PATH="/opt/Qt5.12.3/5.12.3/gcc_64/bin:$PATH"
export PATH="/opt/Qt5.12.3/Tools/QtCreator/bin/:$PATH"











## 无界面安装（未成功）
### 更换软件源

``` shell
# 对于 CentOS 7
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo

# 对于 CentOS 8
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
```

### 执行安装
``` shell
yum groupinstall "Development Tools"
# 失效：sudo yum groupinstall "C Development Tools and Libraries"
sudo yum install wget mesa-libGL-devel -y
tar -xvf qt-everywhere-src-5.12.3.tar.xz
cd qt-everywhere-src-5.12.3
./configure

gmake # 官网显示的是make，但是安装程序显示的是gmake。到此报错，后续未验证，改为图形界面安装。
gmake install
cp /etc/profile /etc/profile.20230424.bak
vi /etc/profile
export PATH=/usr/local/qt-5.12.3/bin:$PATH
source /etc/profile
```

### 示例测试
#### C++ 源码
``` shell
#include <QtGui/QApplication> 
#include <QLabel> 

int main(int argc, char *argv[]) 
{ 
        QApplication a(argc, argv); 
        QLabel *label = new QLabel("Hello, world!"); 
        label->show(); 
        return a.exec(); 
}
```

#### 编译
> 参考：https://www.cnblogs.com/zhaodehua/articles/9603607.html
``` shell
qmake -v    #查看qmake的版本号(个人直接用此命令判断qt是否安装)
which qmake #Linux中which命令，查看可执行文件qmake的位置
qmake -project #根据工程目录生成平台无关的.pro工程文件，pro文件是跨平台的文件
qmake -project QT+=widgets #表示印入QTWidge这个module
make #生成可执行文件
```

```
Note: Also available for Linux: linux-clang linux-icc

Note: No wayland-egl support detected. Cross-toolkit compatibility disabled.

WARNING: QDoc will not be compiled, probably because libclang could not be located. This means that you cannot build the Qt documentation.

Either ensure that llvm-config is in your PATH environment variable, or set LLVM_INSTALL_DIR to the location of your llvm installation.
On Linux systems, you may be able to install libclang by installing the libclang-dev or libclang-devel package, depending on your distribution.
On macOS, you can use Homebrew's llvm package.
On Windows, you must set LLVM_INSTALL_DIR to the installation path.

WARNING: gperf is required to build QtWebEngine.

Qt is now configured for building. Just run 'gmake'.
Once everything is built, you must run 'gmake install'.
Qt will be installed into '/usr/local/Qt-5.12.3'.

Prior to reconfiguration, make sure you remove any leftovers from
the previous build.
```

yum install centos-release-scl