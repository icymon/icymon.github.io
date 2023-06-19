【安装依赖和编译环境】
``` shell
yum install gcc gcc-c++ gcc-gfortran readline-devel libXt-devel fonts-chinese tcl tcl-devel tclx tk tk-devel mesa-libGLU mesa-libGLU-devel
yum install libpng libpng-devel libtiff libtiff-devel libjpeg-turbo libjpeg-turbo-devel cairo-devel libssl-dev httpd readline-devel libXt-devel bzip2-devel xz-devel.x86_64 libcurl-devel zlib-devel pcre2-devel glibc-headers texinfo.x86_64 texlive-pdftex-doc.noarch tex texlive-scheme-basic  -y
yum install centos-release-scl devtoolset-10-gcc devtoolset-10-gcc-c++ devtoolset-10-gcc-gfortran wget -y
yum -y install texlive texlive-latex texlive-xetex texlive-collection-latex texlive-collection-latexrecommended texlive-xetex-def texlive-collection-xetex texlive-collection-latexextra
# yum install centos-release-scl devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-gcc-gfortran wget -y
# yum remove devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-gcc-gfortran -y
scl enable devtoolset-10 bash # 或者在/etc/profile中添加source /opt/rh/devtoolset-10/enable
```
【安装Java（安装R前提）】
``` shell
wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.rpm
# wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.deb

# 用文本编辑器打开/etc/profile 在profile文件末尾加入：
export JAVA_HOME=/usr/lib/jvm/jdk-20-oracle-x64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

【下载源代码解压编译安装】
``` shell
# wget https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-4/R-4.0.0.tar.gz --no-check-certificate
wget https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-4/R-4.3.0.tar.gz --no-check-certificate
mkdir /usr/local/software/R4 -p
./configure --enable-R-shlib=yes --with-tcltk --prefix=/usr/local/software/R4
make
# 需要复制下文件，解决文件缺失问题，否则会有编译问题，如果安装了texlive，就不会出现
# cp doc/NEWS.rds doc/NEWS.2.rds
# cp doc/NEWS.rds doc/NEWS.3.rds
make install
ln -s /usr/local/software/R4/bin/R /usr/bin/R
ln -s /usr/local/software/R4/bin/R /usr/local/bin/R
yum install libxml2 libxml2-devel -y
install.packages("devtools") 
install.packages("xml2")
install.packages("gridtext")
```

【安装Rstudio】
``` shell
wget https://download2.rstudio.org/server/centos7/x86_64/rstudio-server-rhel-2023.03.0-386-x86_64.rpm
sudo yum install rstudio-server-rhel-2023.03.0-386-x86_64.rpm
```

【ubuntu安装R】
```
sudo apt-get install build-essential gfortran libxt-dev libreadline6-dev libbz2-dev liblzma-dev libcurl4-openssl-dev gawk unzip libxt-dev zlib1g-de
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.zip --no-check-certificate
./configure
make && make install

wget https://www.openssl.org/source/openssl-1.1.1u.tar.gz

# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
#  apt-key用法
# apt-key list          # 列出已保存在系统中key。
# apt-key add keyname   # 把下载的key添加到本地trusted数据库中。
# apt-key del keyname   # 从本地trusted数据库删除key。
# apt-key update        # 更新本地trusted数据库，删除过期没用的key。
# rstudio 安装包
https://download1.rstudio.org/electron/focal/amd64/rstudio-2023.06.0-421-amd64-debian.tar.gz
https://download1.rstudio.org/electron/focal/amd64/rstudio-2023.06.0-421-amd64.deb
https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.06.0-421-amd64.deb
https://posit.co/download/rstudio-desktop/
```
【登录】
* 默认端口为8787，需要防火墙放行
* 登录用户名密码为Linux用户名密码