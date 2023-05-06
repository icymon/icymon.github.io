# CentOS7安装armadillo
## 安装默认版本
``` shell
yum install armadillo-devel.x86_64 armadillo.x86_64 -y 
```

以上命令会自动安装blas、lapack
``` shell
yum install blas blas-devel lapack lapack-devel -y
```
## 安装指定版本

> Recommended packages to install before installing Armadillo:
* Fedora & Red Hat: cmake, openblas-devel, lapack-devel, arpack-devel, SuperLU-devel
* Ubuntu & Debian: cmake, libopenblas-dev, liblapack-dev, libarpack2-dev, libsuperlu-dev

``` shell
# tar -xvf armadillo-12.2.0.tar.xz
# cd armadillo-12.2.0
# cmake .
# make install
...
/usr/lib64/armadillo.so
/usr/include/armadillo
...
```
---
## C++ 代码测试
``` shell
$ cat testArmadillo.cpp
#include <iostream>
#include <armadillo>

using namespace std;
using namespace arma;

int main (){

mat A(4, 5);
cout << A.n_rows << endl;

return 0;

}

$ g++ testArmadillo.cpp
$ ./a.out
4
```