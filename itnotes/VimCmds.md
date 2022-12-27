### 设置行号

> 编辑~/.vimrc文件，加入

``` shell
set number
```

### 跳到指定行


> 在vim中有3中方法可以跳转到指定行（按esc进入命令行模式）：
>> 1、跳转到文件第n行，无需回车

``` shell
$ ngg/nG
```
>> 2、跳转到文件第n行，需要回车

``` shell
$ :n 
```

>> 3、打开文件时跳转到第n行

``` shell
$ vim +n filename
```

### 翻屏

``` shell
Ctrl+f 向前翻屏
Ctrl+b 向后翻屏
Ctrl+d 向前翻半屏
Ctrl+u 向后翻半屏
```
