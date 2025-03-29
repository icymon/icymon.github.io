1、管理员权限启动powershell

``` shell
# 其中 ItemType 的取值可选：HardLink、SymbolicLink、Junction
New-Item "C:\wamp64\bin\apache\apache2.4.41\bin\php.ini" -ItemType SymbolicLink -Target "C:\wamp64\bin\php\php7.3.12\phpForApache.ini"
```

2、创建链接还可以通过 dos 命令 mklink创建。