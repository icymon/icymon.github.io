


# 银河麒麟V10SP1安装MySQL5.5.40

> 特别注意在解压、编译及程序执行环节，由于麒麟系统的安全策略，需要及时点击弹出的会话框【允许】

``` shell
sudo apt-get install cmake
sudo apt-get install bison
sudo apt-get install gcc
sudo apt-get install g++
sudo apt-get install libncurses5-dev
```

## [下载源码安装包(点击此处进入MySQL官网下载处)](https://downloads.mysql.com/archives/community/)
``` shell
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.5.40-linux2.6-x86_64.tar.gz
sudo tar -zxvf mysql-5.5.40-linux2.6-x86_64.tar.gz  -C /usr/local/
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql
sudo chown -R mysql:mysql /usr/local/mysql
cd /usr/local/mysql/scripts
sudo ./mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/
sudo mkdir /etc/mysql
sudo cp /usr/local/mysql/support-files/my-medium.cnf /etc/mysql/my.cnf
sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sudo cp /etc/profile /etc/profile.bak
sudo vi /etc/profile
在文件最后增加一行：export PATH=$PATH:/usr/local/mysql/bin
source /etc/profile
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/libncurses.so.5

```
* 添加系统守护进程，方便启动关闭
``` shell 
sudo vi /etc/systemd/system/mysqld.service
```

> 添加如下内容：

```
[Unit]
Description=MySQL Server
After=network.target
 
[Service]
ExecStart=/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/mysql/my.cnf --datadir=/usr/local/mysql/data
User=mysql
Group=mysql
WorkingDirectory=/usr/local/mysql
 
[Install]
WantedBy=multi-user.target
```

``` shell
sudo systemctl daemon-reload
sudo systemctl status mysqld # 查看MySQL的状态
sudo systemctl start mysqld # 启动MySQL
sudo systemctl stop mysqld # 关闭MySQL
```

* 修改root密码

```
mysql -uroot #空密码
> use mysql
> update user set password=password('Admin123') where user='root';
> flush privileges;
```




# 银河麒麟V10SP1安装MySQL5.5.40(源码编译)，失败，未继续

> 特别注意在解压、编译及程序执行环节，由于麒麟系统的安全策略，需要及时点击弹出的会话框【允许】

## 安装依赖

``` shell
sudo apt-get install cmake
sudo apt-get install bison
sudo apt-get install gcc
sudo apt-get install g++
sudo apt-get install  libncurses5-dev
```

## [下载源码安装包(点击此处进入MySQL官网下载处)](https://downloads.mysql.com/archives/community/)
``` shell
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.5.40.tar.gz
sudo tar -zxvf mysql-5.5.40.tar.gz  -C /usr/local/
cd /usr/local/mysql-5.5.40
sudo mkdir Build
cd build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/ -DMYSQL_DATADIR=/usr/local/mysql/data/ -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_TCP_PORT=3306 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DMYSQL_USER=mysql -DWITH_DEBUG=0 -DSYSCONFDIR=/etc
```
* `cmake`之后出现如下信息，说明`cmake`成功

```
-- Configuring done
-- Generating done
CMake Warning:
  Manually-specified variables were not used by the project:

    MYSQL_USER


-- Build files have been written to: /usr/local/mysql-5.5.40
```

``` shell

sudo make 编译失败
sudo make install
```