# ERROR: PACKAGE OR NAMESPACE LOAD FAILED FOR 'RJAGS'

> https://www.appsloveworld.com/r/100/86/error-package-or-namespace-load-failed-for-rjags

> https://www.jianshu.com/p/b0fef9d09903


``` shell
conda create -n rjags_env -c conda-forge r-rjags
conda activate rjags_env
conda config --env --add channels conda-forge
conda install pkg-config jags
```

* 安装完注销登录，用户重登再执行```install.packages("rjags")```

# canda添加清华的源

``` shell
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --set show_channel_urls yes
conda config --show-sources
```