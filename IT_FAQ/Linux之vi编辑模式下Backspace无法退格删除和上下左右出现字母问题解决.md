Linux之vi编辑模式下Backspace无法退格删除和上下左右出现字母问题解决
vi编辑模式下上下左右出现字母
``` shell
sudo vi  /etc/vim/vimrc.tiny
```

* 修改　　set compatible  为  set nocompatible      设置是否兼容
* 添加　　set backspace=2　　　　　　　　　     设置 backspace可以删除任意字符