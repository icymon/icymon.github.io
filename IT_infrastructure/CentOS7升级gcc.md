# CentOS7升级gcc
* 有如下类型的报错

``` shell
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by ...)
/lib64/libstdc++.so.6: version `CXXABI_1.3.9' not found (required by ...)
/lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by ...)
```
## 下载GCC编译安装
``` shell
yum groupinstall "Development Tools"
wget https://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.gz --no-check-certificate
tar -zxvf  gcc-7.3.0.tar.gz
cd gcc-7.3.0/
./contrib/download_prerequisites
mkdir build
cd build
../configure --enable-checking=release --enable-languages=c,c++  --disable-multilib
make
make install
 
```

## 验证
``` shell
# 检查验证
strings /usr/lib64/libstdc++.so.6 | grep 'CXXABI'
# 如未发现则全局查找 
find / -name "libstdc++.so.*"
# 发现刚才编译的在这
/usr/local/lib64/libstdc++.so.6.0.24
# 创建软连接
cp /usr/local/lib64/libstdc++.so.6.0.24 /usr/lib64/
cp /usr/lib64/libstdc++.so.6 /home/libstdc++.so.6.bak
rm /usr/lib64/libstdc++.so.6
ln -s /usr/lib64/libstdc++.so.6.0.24 /usr/lib64/libstdc++.so.6
# 检查验证
strings /usr/lib64/libstdc++.so.6 | grep 'CXXABI'
strings /usr/lib64/libstdc++.so.6 | grep 'GLIBCXX'
```