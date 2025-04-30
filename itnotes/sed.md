### sed使用方法
``` shell
#sed -i "s/^.*user10.*$/aaaaaaaaaa/" useradd.txt
```
### 用法辨析
``` shell
$ sed '$a xxxx' yarn-env.sh # 不会对原文件进行修改，只是把在文件末尾添加xxxx后的结果输出到终端。
$ sed -i '$a yyyy' yarn-env.sh # 会直接在原文件的末尾添加yyyy
```