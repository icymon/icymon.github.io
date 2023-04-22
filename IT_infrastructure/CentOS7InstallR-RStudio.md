【安装依赖和编译环境】
``` shell
yum install gcc gcc-c++ gcc-gfortran readline-devel libXt-devel fonts-chinese tcl tcl-devel tclx tk tk-devel mesa-libGLU mesa-libGLU-devel
yum install libpng libpng-devel libtiff libtiff-devel libjpeg-turbo libjpeg-turbo-devel cairo-devel libssl-dev httpd readline-devel libXt-devel bzip2-devel xz-devel.x86_64 libcurl-devel zlib-devel pcre2-devel glibc-headers texinfo.x86_64 texlive-pdftex-doc.noarch tex texlive-scheme-basic  -y
yum install centos-release-scl devtoolset-10-gcc devtoolset-10-gcc-c++ devtoolset-10-gcc-gfortran wget -y
scl enable devtoolset-10 bash # 或者在/etc/profile中添加source /opt/rh/devtoolset-10/enable
```
【下载源代码解压编译安装】
``` shell
wget https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-4/R-4.0.0.tar.gz --no-check-certificate
mkdir /usr/local/software/R4 -p
./configure --enable-R-shlib=yes --with-libpng-x=no --with-tcltk --prefix=/usr/local/software/R4
make
# 需要复制下文件，解决文件缺失问题，否则会有编译问题
cp doc/NEWS.rds NEWS.2.rds
cp doc/NEWS.rds NEWS.2.rds
make install
ln -s /usr/local/software/R4/bin/R /usr/local/bin/R
yum install libxml2 libxml2-devel -y
install.packages("devtools") 
install.packages("xml2")
install.packages("gridtext")
```
【安装Java】
``` shell
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
# 用文本编辑器打开/etc/profile 在profile文件末尾加入：
export JAVA_HOME=/usr/lib/jvm/jdk-20-oracle-x64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```
【安装Rstudio】
``` shell
wget https://download2.rstudio.org/server/centos7/x86_64/rstudio-server-rhel-2023.03.0-386-x86_64.rpm
sudo yum install rstudio-server-rhel-2023.03.0-386-x86_64.rpm
```

【登录】
* 默认端口为8787，需要防火墙放行
* 登录用户名密码为Linux用户名密码