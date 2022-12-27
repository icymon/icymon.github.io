### tar常用命令

#### 参数：

> -c ：create 建立压缩档案的参数  
> -x ： 解压缩压缩档案的参数  
> -z ： 是否需要用gzip压缩  
> -v： 压缩的过程中显示档案  
> -f： 置顶文档名，在f后面立即接文件名，不能再加参数  

#### 压缩
* 将整个/home/www/images 目录下的文件全部打包为 /home/www/images.tar

``` shell
# 仅打包，不压缩
tar -cvf /home/www/images.tar /home/www/images
# 打包后，以gzip压缩
tar -zcvf /home/www/images.tar.gz /home/www/images
# 将目录里所有jpg文件打包成jpg.tar
tar –cvf jpg.tar *.jpg
```

* 将指定目录压缩到指定文件

比如将linux-2.6.29 目录压缩到 kernel.tgz

``` shell
tar czvf kernel.tgz linux-2.6.29
```

在参数f后面的压缩文件名是自己取的，习惯上用tar来做，如果加z参数，则以tar.gz 或tgz来代表gzip压缩过的tar file文件

#### 解压
``` shell
# 将/source/kernel.tgz解压到 /source/linux-2.6.29 目录
tar zxvf /source/kernel.tgz -C /source/ linux-2.6.29
```


